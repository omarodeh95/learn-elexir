defmodule Discuss.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller
  use DiscussWeb, :verified_routes

  def init(_params) do
  end

  def call(conn, _params) do
    # if there is now user, then halt()
    if conn.assigns.user do
      conn
    else
      conn
      |> put_flash(:error, "You need to be logged in")
      |> redirect(to: ~p"/topics")
      |> halt()
    end
  end
end
