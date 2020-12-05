defmodule TrelloTaskerWeb.CardLive do
  use TrelloTaskerWeb, :live_view

  alias Phoenix.View
  alias TrelloTasker.Shared.Services.Trello
  alias TrelloTaskerWeb.CardView

  @impl true
  def mount(_params, _session, socket) do
    card = Trello.get_card()
    {:ok, assign(socket, cards: [card, card, card])}
  end

  @impl true
  def render(assigns) do
    View.render(CardView, "index.html", assigns)
  end
end
