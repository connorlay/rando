defmodule Rando.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:points, :integer, default: 0, null: false)
      timestamps()
    end

    create(constraint(:users, :points_ranges, check: "points >= 0 and points <= 100"))
  end
end
