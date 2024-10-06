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
    # This function is going to wait untill a client/connection is received
    {:ok, client} = :gen_tcp.accept(socket)

    # Start a supervised process
    {:ok, pid} = Task.Supervisor.start_child(KVServer.TaskSupervisor, fn -> serve(client) end)

    # The client controller process is the loop_acceptor process
    # if the loop accepter failed, all connections are closed
    # We need to change that and tie the connecction with the child process created above
    :ok = :gen_tcp.controlling_process(client, pid)

    # recursively accept new connections
    loop_acceptor(socket)
  end

  defp serve(socket) do
    msg =
      case read_line(socket) do
        {:ok, data} ->
          case KVServer.Command.parse(data) do
            {:ok, command} ->
              KVServer.Command.run(command)

            {:error, _} = err ->
              err
          end

        {:error, _} = err ->
          err
      end

    write_line(socket, msg)
    serve(socket)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, {:ok, text}) do
    :gen_tcp.send(socket, text)
  end

  defp write_line(socket, {:error, :unknown_command}) do
    # Unkown command response
    :gen_tcp.send(socket, "UNKNOWN COMMAND\r\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    # shutdown the process if the connection is closed
    exit(:shutdown)
  end

  defp write_line(socket, {:error, error}) do
    # Unkown error, exiting the process
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end
end
