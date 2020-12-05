defmodule TrelloTaskerWeb.CardInfoLive do
  use TrelloTaskerWeb, :live_view

  alias Phoenix.View
  alias TrelloTaskerWeb.CardView

  @impl true
  def mount(_params, _session, socket) do
    card_info = TrelloTasker.Shared.Services.Trello.get_card()
    comments = TrelloTasker.Shared.Services.Trello.get_comments()
    {:ok, assign(socket, comments: comments, card: card_info)}
  end

  @impl true
  def render(assigns) do
    View.render(CardView, "info.html", assigns)
  end
end
