defmodule TrelloTaskerWeb.CardLive do
  use TrelloTaskerWeb, :live_view

  alias Phoenix.View
  alias TrelloTasker.Shared.Services.Trello
  alias TrelloTaskerWeb.CardView
  alias TrelloTasker.Cards
  alias TrelloTasker.Cards.Card

  @impl true
  def mount(_params, _session, socket) do
    changeset = Card.changeset(%Card{})

    cards =
      Cards.list_cards()
      |> IO.inspect
      |> Enum.map(&Trello.get_card(&1.path))

    {:ok, assign(socket, changeset: changeset, cards: cards)}
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
            card
            |> Cards.create_card()
            |> response(socket)
        end
    end
  end

  def response({:error, changeset}, socket), do: {:noreply, assign(socket, :changeset, changeset)}

  def response({:ok, _card}, socket),
    do:
      {:noreply,
       socket
       |> put_flash(:info, "Card Criado com Sucesso!")
       |> push_redirect(to: "/")}
end
