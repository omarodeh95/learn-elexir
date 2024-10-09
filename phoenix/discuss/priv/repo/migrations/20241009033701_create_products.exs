defmodule Discuss.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :title, :string

      timestamps(type: :utc_datetime)
    end
  end
end
