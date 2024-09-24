defmodule DiscussWeb.TopicsHTML do
  @moduledoc """
  This module contains topics rendered by TopicsController.

  See the `topics_html` directory for all templates available.
  """
  use DiscussWeb, :html

  embed_templates "topics_html/*"

  attr :changeset, Ecto.Changeset, required: true

  def topic_form(assigns)
end
