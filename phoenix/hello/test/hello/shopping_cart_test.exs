defmodule Hello.ShoppingCartTest do
  use Hello.DataCase

  alias Hello.ShoppingCart

  describe "carts" do
    alias Hello.ShoppingCart.Cart

    import Hello.ShoppingCartFixtures

    @invalid_attrs %{user_uuid: nil}

    test "list_carts/0 returns all carts" do
      cart = cart_fixture()
      assert ShoppingCart.list_carts() == [cart]
    end

    test "get_cart!/1 returns the cart with given id" do
      cart = cart_fixture()
      assert ShoppingCart.get_cart!(cart.id) == cart
    end

    test "create_cart/1 with valid data creates a cart" do
      valid_attrs = %{user_uuid: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Cart{} = cart} = ShoppingCart.create_cart(valid_attrs)
      assert cart.user_uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.create_cart(@invalid_attrs)
    end

    test "update_cart/2 with valid data updates the cart" do
      cart = cart_fixture()
      update_attrs = %{user_uuid: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %Cart{} = cart} = ShoppingCart.update_cart(cart, update_attrs)
      assert cart.user_uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_cart/2 with invalid data returns error changeset" do
      cart = cart_fixture()
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.update_cart(cart, @invalid_attrs)
      assert cart == ShoppingCart.get_cart!(cart.id)
    end

    test "delete_cart/1 deletes the cart" do
      cart = cart_fixture()
      assert {:ok, %Cart{}} = ShoppingCart.delete_cart(cart)
      assert_raise Ecto.NoResultsError, fn -> ShoppingCart.get_cart!(cart.id) end
    end

    test "change_cart/1 returns a cart changeset" do
      cart = cart_fixture()
      assert %Ecto.Changeset{} = ShoppingCart.change_cart(cart)
    end
  end
end
