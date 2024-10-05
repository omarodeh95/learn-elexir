defmodule KV.Registry do
  use GenServer

  # Client code

  @doc """
  Starts the registry
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Lookup a bucket in the registry

  Returns {:ok, pid} if the bucket exists, returns :error otherwise
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Create a new name in the registry

  Ensures that there is a bucket associated with the given 'name' in 'server'
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end


  # Server code

  @impl true
  def init(:ok) do
    {:ok, {%{}, %{}}}
  end

  @impl true
  def handle_call({:lookup, name}, _from, {names, _refs} = state) do
    {:reply, Map.fetch(names, name), state}
  end

  @impl true
  def handle_cast({:create, name}, {names, refs} = state) do
    if  Map.has_key?(names, name) do
      # do nothing
      {:noreply, state}
    else
      # create new bucket
      # {:ok, bucket} = KV.Bucket.start_link([])
      {:ok, bucket} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
      ref = Process.monitor(bucket)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, bucket)
      {:noreply, {names, refs}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  @impl true
  def handle_info(msg, state) do
    require Logger
    Logger.debug("Unexpected message in KV.Registry: #{inspect(msg)}")
    {:noreply, state}
  end
end
