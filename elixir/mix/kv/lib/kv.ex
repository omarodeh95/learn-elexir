defmodule KV do
  use Application

  @impl true
  def start(_type, _args) do
    KV.Supervisor.start_link(name: KV.Supervisor)
  end
end
# defmodule KV do
#   @moduledoc """
#   Documentation for `KV`.
#   """
#
#   @doc """
#   Hello world.
#
#   ## Examples
#
#       iex> KV.hello()
#       :world
#
#   """
#   def hello do
#     :world
#   end
# end
