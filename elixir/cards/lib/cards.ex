defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  @doc """
    Generates a list of strings
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Diamonds", "Hearts"]

    # This is called comprehension, and it is like a map!, it comes from the same concept of immutability

    # The wrong way of doing it (list comprehension)
    # for suit <- suits  do
    #   for value <- values do
    #     "#{value} of #{suit}"
    #   end
    # end

    # First approach to solve it is by using a Linked list
    # cards = for suit <- suits  do
    #   for value <- values do
    #     "#{value} of #{suit}"
    #   end
    # end
    # List.flatten(cards)

    # Second approach and it is without using a linked list, using multiple comprehension
    for value <- values, suit <- suits  do
        "#{value} of #{suit}"
    end

  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Determines whether a deck contains a given card

  ## Examples
      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Ace of Spades")
      true 
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    Divides a deck into a hand and the remainder of the dock.
    The `hand_size` argument indicates how many cards should be in the hand.

  ## Examples
      iex> deck = Cards.create_deck
      iex> {hand, _deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of Spades"]
  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    # try and and save with filename of "my_deck" and check the project dir
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> "That file does not exist"
    end
  end

  def create_hand(hand_size) do
    create_deck()|> shuffle()|> deal(hand_size)
  end
end
