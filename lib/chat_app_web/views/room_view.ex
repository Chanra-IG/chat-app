defmodule ChatAppWeb.RoomView do

  use ChatAppWeb, :view

  def render("list.json", %{rooms: rooms}) do
    %{data: render_many(rooms, ChatAppWeb.RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{
      id: room.id,
      name: room.name
    }
  end
end
