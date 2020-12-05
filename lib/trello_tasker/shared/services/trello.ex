defmodule TrelloTasker.Shared.Services.Trello do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.trello.com/1/cards"
  plug Tesla.Middleware.Headers, [{"User-Agent", "request"}]
  plug Tesla.Middleware.JSON

  @token "ae35721b808c15d75fc663331f7c4a29e092a440b6eb0dd6a1a3ba1e3e3bd56e"
  @key "ee1fa4b7d0f9279cc3a8714291fee1d1"

  def get_comments() do
    {:ok, response} =
      ("5hikTQPb/actions?commentCard&key=" <> @key <> "&token=" <> @token)
      |> get()

    body = response.body

    body
    |> Enum.map(&%{text: &1["data"]["text"], user: &1["memberCreator"]["username"]})
  end

  def get_card(card_id) do
    {:ok, response} =
      ("#{card_id}?list=true&comments=true&key=" <> @key <> "&token=" <> @token)
      |> get()

    status = response.status

    if status != 200 do
      {:error, "Erro ao buscar o card"}
    else
      body = response.body

      IO.inspect(body)

      {:ok, deliver_date, _} =
        body["due"]
        |> DateTime.from_iso8601()

      %{
        image: body["cover"]["sharedSourceUrl"],
        id: body["id"],
        name: body["name"],
        description: body["desc"],
        deliver_date: deliver_date |> DateTime.to_date(),
        completed: body["dueComplete"]
      }
    end
  end
end
