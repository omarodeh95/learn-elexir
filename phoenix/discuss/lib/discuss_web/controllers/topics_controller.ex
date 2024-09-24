defmodule DiscussWeb.TopicsController do
  use DiscussWeb, :controller
  import Ecto.Query
  alias Discuss.Topic
  alias Discuss.Repo
  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    topics = (from t in Topic, preload: [:comments, :user])
             |> Repo.all

    render conn, :index, topics: topics
  end

  def new(conn, _params) do
    render(conn, :new, changeset: Topic.changeset(%Topic{user_id: conn.assigns.user.id}, %{}))
  end

  def show(conn, %{"id" => id} = _params) do
    topic = (from t in Topic, preload: [:comments, :user])
            |> Repo.get!(id)

    render conn, :show, topic: topic
  end

  def create(conn, %{"topic" => topic} = _params) do
    changeset = conn.assigns.user
      |> Ecto.build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _post} -> 
        conn
        |> redirect(to: ~p"/topics")
      {:error, changeset} ->
        IO.inspect(changeset)
        render conn, :new, changeset: changeset
    end
  end

  def edit(conn, %{"id" => id}) do
    changeset = Repo.get!(Topic, id) |> Topic.changeset(%{})
    render conn, :edit, changeset: changeset
  end

  def update(conn, %{"topic" => topic, "id" => id} = _params) do
    changeset = Repo.get!(Topic, id) |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, _put} -> 
        conn
        |> redirect(to: ~p"/topics")
      {:error, changeset} ->
        render conn, :edit, changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    {:ok, _topic} =
      Repo.get!(Topic, id)
      |> Repo.delete()

    conn
    |> redirect(to: ~p"/topics")
  end

  defp check_topic_owner(conn, _params) do
    %{params: %{"id" => id}} = conn
    if Repo.get!(Topic, id).user_id== conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You are not the owner of this Topic")
      |> redirect(to: ~p"/topics")
      |> halt()
    end
  end
end

