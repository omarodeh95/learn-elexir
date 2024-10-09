defmodule Discuss.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
