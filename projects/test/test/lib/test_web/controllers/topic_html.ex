defmodule TestWeb.TopicHTML do
  use TestWeb, :html

  embed_templates "topic_html/*"

  @doc """
  Renders a topic form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def topic_form(assigns)
end
