defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias Discuss.{Topic, Repo, Comment}

  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
      |> Repo.get!(topic_id)
      |> Repo.preload(:comments)

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in("comments:add", %{"content" => content}, socket) do
    topic = socket.assigns.topic
    changeset = topic
      |> Ecto.build_assoc(:comments)
      |> Comment.changeset(%{content: content, user_id: socket.assigns.user.id})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}
      {:error, _message} ->
        {:reply, {:error, errors: changeset}, socket}
    end
  end
end
