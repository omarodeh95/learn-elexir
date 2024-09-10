defmodule Discuss.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.Topic

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    has_many :topics, Topic
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end
end

