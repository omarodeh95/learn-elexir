defmodule DiscussWeb.TopicsController do
  use DiscussWeb, :controller
  import Ecto.Query
  alias Discuss.Topic
  alias Discuss.Repo

  def index(conn, _params) do
    topics = (from t in Topic, preload: [:comments, :user])
             |> Repo.all

    render conn, :index, layout: false, topics: topics
  end

  def new(conn, _params) do
    render(conn, :new, layout: false, changeset: Topic.changeset(%Topic{}, %{}))
  end

  def show(conn, %{"id" => id} = _params) do
    topic = (from t in Topic, preload: [:comments, :user])
            |> Repo.get!(id)

    render conn, :show, layout: false, topic: topic
  end

  def create(conn, %{"topic" => topic} = _params) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _post} -> 
        conn
        |> redirect(to: ~p"/topics")
      {:error, changeset} ->
        render conn, :new, layout: false, changeset: changeset
    end
  end

  def edit(conn, %{"id" => id}) do
    changeset = Repo.get!(Topic, id) |> Topic.changeset(%{})
    render conn, :edit, layout: false, changeset: changeset
  end

  def update(conn, %{"topic" => topic, "id" => id} = _params) do
    changeset = Repo.get!(Topic, id) |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, _put} -> 
        conn
        |> redirect(to: ~p"/topics")
      {:error, changeset} ->
        render conn, :edit, layout: false, changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    {:ok, _topic} =
      Repo.get!(Topic, id)
      |> Repo.delete()

    conn
    |> redirect(to: ~p"/topics")
  end
end

