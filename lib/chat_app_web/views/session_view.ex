defmodule ChatAppWeb.SessionView do
  use ChatAppWeb, :view

  def render("login.json", %{user: user, token: token}) do
    %{
      data: %{
        id: user.id,
        username: user.username,
        token: token,
      }
    }
  end


end
