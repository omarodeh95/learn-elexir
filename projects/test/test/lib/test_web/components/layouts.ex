defmodule TestWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use TestWeb, :controller` and
  `use TestWeb, :live_view`.
  """
  use TestWeb, :html

  embed_templates "layouts/*"
end
