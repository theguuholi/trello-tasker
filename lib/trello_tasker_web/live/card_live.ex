defmodule TrelloTaskerWeb.CardLive do
  use TrelloTaskerWeb, :live_view

  alias Phoenix.View
  alias TrelloTasker.Shared.Services.Trello
  alias TrelloTaskerWeb.CardView
  alias TrelloTasker.Cards.Card

  @impl true
  def mount(_params, _session, socket) do
    changeset = Card.changeset(%Card{})
    card = Trello.get_card("5hikTQPb")
    {:ok, assign(socket, changeset: changeset, cards: [card, card, card])}
  end

  @impl true
  def render(assigns) do
    View.render(CardView, "index.html", assigns)
  end

  @impl true
  def handle_event("search", %{"card" => card}, socket) do
    changeset = Card.changeset(%Card{}, card)
    changeset = %Ecto.Changeset{changeset | action: :insert}

    changeset.valid?
    |> case do
      false ->
        {:noreply, assign(socket, :changeset, changeset)}

      true ->
        card["path"]
        |> Trello.get_card()
        |> case do
          {:error, msg} ->
            {:noreply,
             socket
             |> put_flash(:error, msg)
             |> push_redirect(to: "/")}

          card_info ->
            {:noreply,
             socket
             |> put_flash(:info, "Card Criado com Sucesso!")
             |> push_redirect(to: "/")}
        end
    end
  end
end
