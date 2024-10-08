defmodule HelloWeb.HelloHTML do
  use HelloWeb, :html

  # def index(assigns) do
  #   ~H"""
  #   Hi!
  #   """
  # end
  embed_templates "hello_html/*"
end
