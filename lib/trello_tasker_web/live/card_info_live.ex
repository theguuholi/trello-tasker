defmodule TrelloTaskerWeb.CardInfoLive do
  use TrelloTaskerWeb, :live_view

  alias Phoenix.View
  alias TrelloTaskerWeb.CardView

  @impl true
  def mount(%{"card_id" => card_id}, _session, socket) do
    card_info = TrelloTasker.Shared.Services.Trello.get_card(card_id)
    comments = TrelloTasker.Shared.Services.Trello.get_comments(card_id)
    {:ok, assign(socket, comments: comments, card: card_info)}
  end

  @impl true
  def render(assigns) do
    View.render(CardView, "info.html", assigns)
  end
end
