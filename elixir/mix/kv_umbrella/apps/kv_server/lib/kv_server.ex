defmodule KVServer do
  require Logger

  def accept(port) do

    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connection on port #{port}")

    # Start accepting clients
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket) # This function is going to wait untill a client/connection is received

    # Start a supervised process
    {:ok, pid} = Task.Supervisor.start_child(KVServer.TaskSupervisor, fn -> serve(client) end)

    # The client controller process is the loop_acceptor process
    # if the loop accepter failed, all connections are closed
    # We need to change that and tie the connecction with the child process created above
    :ok = :gen_tcp.controlling_process(client, pid)

    loop_acceptor(socket) # recursively accept new connections
  end
  
  defp serve(socket) do
    socket
    |> read_line
    |> write_line(socket)

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)

    data
  end

  defp write_line(line, socket) do
     :gen_tcp.send(socket, line)
  end
end
