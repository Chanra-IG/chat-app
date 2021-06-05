defmodule ChatAppWeb.SessionController do
  use ChatAppWeb, :controller

  alias ChatApp.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Accounts.sign_in(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "You've signed in")
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid Email or Password")
        |> render("new.html")
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.sign_in(email, password) do
      {:ok, user} ->
        token = Phoenix.Token.sign(conn, "user token", user.id)
        conn
        |> put_status(:ok)
        |> put_view(ChatAppWeb.SessionView)
        |> render("login.json", %{user: user, token: token})
      {:error, _} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(ChatAppWeb.ErrorView)
        |> render("401.json", message: "Invalid Email or Password")
    end
  end

  def delete(conn, _) do
    conn
    |> Accounts.sign_out()
    |> redirect(to: Routes.room_path(conn, :index))
  end

  def get_token(conn, %{"id" => id}) do
    token = Phoenix.Token.sign(conn, "user token", id)
    json conn, %{token: token}
  end
end
