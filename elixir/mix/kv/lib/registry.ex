defmodule KV.Registry do
  use GenServer

  # Client code

  @doc """
  Starts the registry
  """
  def start_link(opts) do
    # simple the table name is passed as a keyword list, but not as init state arg
    server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, server, opts)
  end

  @doc """
  Lookup a bucket in the registry

  Returns {:ok, pid} if the bucket exists, returns :error otherwise
  """
  def lookup(table, name) do
    case :ets.lookup(table, name) do
      [{^name, pid}] -> {:ok, pid}
      [] -> :error
    end

    # GenServer.call(table, {:lookup, name})
  end

  @doc """
  Create a new name in the registry

  Ensures that there is a bucket associated with the given 'name' in 'server'
  """
  def create(server, name) do
    GenServer.call(server, {:create, name})
  end

  # Server code

  @impl true
  def init(table) do
    names = :ets.new(table, [:named_table, read_concurrency: true])
    refs = %{}
    {:ok, {names, refs}}
  end

  @impl true
  def handle_call({:create, name}, _from, {names, refs}) do
    case lookup(names, name) do
      {:ok, pid} ->
        {:reply, pid, names}

      :error ->
        {:ok, pid} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
        ref = Process.monitor(pid)
        refs = Map.put(refs, ref, name)
        :ets.insert(names, {name, pid})
        {:reply, pid, {names, refs}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    :ets.delete(names, name)
    {:noreply, {names, refs}}
  end

  @impl true
  def handle_info(msg, state) do
    require Logger
    Logger.debug("Unexpected message in KV.Registry: #{inspect(msg)}")
    {:noreply, state}
  end
end
