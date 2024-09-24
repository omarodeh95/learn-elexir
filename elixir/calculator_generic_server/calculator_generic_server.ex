defmodule GenericServer do
  # The idea is to maintain a stateful server process while leaving the implementation to the client (module)
  def start(module) do
    spawn(fn ->
      loop(module, module.init()) end
    )
  end

  defp loop(module, current_state) do
    # By convention, call is used for sync calls & we send to the caller process
    # By convention, cast is used for async calls
    receive do
      {:call, request, caller} -> 
        {response, new_state} = module.handle_call(request, current_state)
        send(caller, response)
        loop(module, new_state)
      {:cast, request} ->
        new_state = module.handle_cast(request, current_state)
        loop module, new_state
    end
  end

  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})
    receive do
      response -> 
        IO.puts response
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end
end

defmodule CalculatorServer do
  def start do
    GenericServer.start(CalculatorServer)
  end

  def init, do: 0

  def call(server_pid, request) do
    GenericServer.call(server_pid, request)
  end

  def cast(server_pid, request) do
    GenericServer.cast(server_pid, request)
  end

  def handle_cast(:display, current_state) do
    current_state
  end

  def handle_call(:display, current_state) do
    {current_state, current_state}
  end

  def handle_call({:add, value}, current_state) do
    {"Added!", (current_state + value)}
  end

  def handle_call({:sub, value}, current_state) do
    {"Subtracted!", (current_state - value)}
  end

  def handle_call({:mul, value}, current_state) do
    {"Multiplied!!", (current_state * value)}
  end

  def handle_call({:div, value}, current_state) do
    {"Divided!", (current_state / value)}
  end
end
