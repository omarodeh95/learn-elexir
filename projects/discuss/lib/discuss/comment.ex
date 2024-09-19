defmodule Discuss.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.Topic
  alias Discuss.User

  @derive {Jason.Encoder, only: [:content]}

  schema "comments" do
    field :content, :string
    belongs_to :topic, Topic
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :user_id, :topic_id])
    |> validate_required([:content, :user_id, :topic_id])
  end
end

