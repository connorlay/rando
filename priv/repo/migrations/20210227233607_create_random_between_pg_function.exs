defmodule Rando.Repo.Migrations.CreateRandomBetweenPgFunction do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE FUNCTION random_between(low INT, high INT) 
       RETURNS INT AS
      $$
      BEGIN
       RETURN floor(random() * (high-low + 1) + low);
      END;
      $$ language 'plpgsql' STRICT;
      """,
      """
      DROP FUNCTION random_between(low INT, high INT);
      """
    )
  end
end
