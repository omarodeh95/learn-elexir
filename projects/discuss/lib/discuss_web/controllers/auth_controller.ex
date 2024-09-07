defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  alias Discuss.Repo
  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{email: auth.info.email, provider: "github", token: auth.credentials.token}
    changeset = User.changeset(%User{}, user_params)
    sign_in(conn, changeset)
  end

  defp sign_in(conn, changeset) do
    case create_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome Back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: ~p"/topics")
      {:error, _message} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: ~p"/topics")
    end
  end

  defp create_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        {:ok, Repo.insert!(changeset)}
      user ->
        {:ok, user}
    end
  end
end
