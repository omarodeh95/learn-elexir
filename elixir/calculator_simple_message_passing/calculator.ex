defmodule Calculator do
  def start do
    # spawn the server process, currently the main goal is to track the state
    # Start the calculator state with the value 0
    spawn(fn -> loop(0) end)
  end

  # We are exposing a few functions to interact with the server process
  # Note that the exposed functions are all executed within the call pid
  # Show the current calculator value
  def display(server_pid) do
    send(server_pid, {:display, self()}) # self here is the caller process id, we are sending it to the server process to respond to us

    receive do
      {:response, current_value} ->
        current_value
    end
  end

  # Mathematical operation
  def add(server_pid, value), do: send(server_pid, {:add, value})
  def sub(server_pid, value), do: send(server_pid, {:sub, value})
  def mul(server_pid, value), do: send(server_pid, {:mul, value})
  def div(server_pid, value), do: send(server_pid, {:div, value})

  # loop that is used by the server process
  # It starts by receiving an action, so this process is blocked by default til it receives an action
  # When receiving an action, it process the request within the server process
  # When it does, it recursively loop again to handle any new actions
  defp loop(current_value) do
    new_value = receive do
      {:display, caller_id} ->
        send(caller_id, {:response, current_value})
        current_value
      {:add, value} ->
        current_value + value
      {:sub, value} ->
        current_value - value
      {:mul, value} ->
        current_value * value
      {:div, value} ->
        current_value / value
      _ ->
        IO.puts("Invalid Message")
        current_value
    end

    loop new_value
  end
end
