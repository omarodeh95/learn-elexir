defmodule Test.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Test.Content` context.
  """

  @doc """
  Generate a topic.
  """
  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Test.Content.create_topic()

    topic
  end
end
