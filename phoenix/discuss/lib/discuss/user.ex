defmodule Discuss.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.Topic
  alias Discuss.Comment

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    has_many :topics, Topic
    has_many :comments, Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end
end
