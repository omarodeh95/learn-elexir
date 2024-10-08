defmodule Discuss.Repo.Migrations.CreateUserModel do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :provider, :string
      add :token, :string
    end
  end
end
