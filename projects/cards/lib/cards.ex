defmodule Cards do

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

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    # try and and save with filename of "my_deck" and check the project dir
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end
end
