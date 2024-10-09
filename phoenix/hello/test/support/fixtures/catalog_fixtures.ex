defmodule Hello.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hello.Catalog` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        price: "120.5",
        title: "some title",
        views: 42
      })
      |> Hello.Catalog.create_product()

    product
  end
end
