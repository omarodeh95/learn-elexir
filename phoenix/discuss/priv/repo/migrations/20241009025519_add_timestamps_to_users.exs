defmodule Discuss.Repo.Migrations.AddTimestampsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      timestamps(type: :utc_datetime)
    end
  end
end
