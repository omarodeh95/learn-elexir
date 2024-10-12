defmodule Hello.ShoppingCartFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hello.ShoppingCart` context.
  """

  @doc """
  Generate a unique cart user_uuid.
  """
  def unique_cart_user_uuid do
    raise "implement the logic to generate a unique cart user_uuid"
  end

  @doc """
  Generate a cart.
  """
  def cart_fixture(attrs \\ %{}) do
    {:ok, cart} =
      attrs
      |> Enum.into(%{
        user_uuid: unique_cart_user_uuid()
      })
      |> Hello.ShoppingCart.create_cart()

    cart
  end
end
