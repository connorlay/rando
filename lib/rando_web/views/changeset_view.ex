defmodule RandoWeb.ChangesetView do
  use RandoWeb, :view

  def render("error.json", %{changeset: changeset}) do
    error_msg = Ecto.Changeset.traverse_errors(changeset, fn {msg, _errors} -> msg end)
    %{error: error_msg}
  end
end
