defmodule Discuss.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.User
  alias Discuss.Comment

  schema "topics" do
    field :title, :string
    belongs_to :user, User
    has_many :comments, Comment
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end
end

