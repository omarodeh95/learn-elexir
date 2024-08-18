defmodule DiscussWeb.TopicsController do
  use DiscussWeb, :controller
  alias Discuss.Topic

  def new(conn, _params) do
    render(conn, :new, layout: false, changeset: Topic.changeset(%Topic{}, %{}))
  end

  def create(conn, %{"topic" => topic} = params) do
    IO.inspect(params)
  end
end

