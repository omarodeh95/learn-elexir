defmodule Discuss.Plugs.SetUser do
  import Plug.Conn # helper function to the conn

  alias Discuss.{User, Repo}

  def init(_params) do
    # This will have some setup
  end

  def call(conn, _params) do
    # This will get called when plugged
    # Called with a conn, and returns a conn -> which is a plug
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && User |> Repo.get!(user_id) ->
        assign(conn, :user, user)
      true -> 
        assign(conn, :user, nil)
    end
  end
end
