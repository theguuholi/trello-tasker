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

  def get_card() do
    {:ok, response} =
      ("5hikTQPb?list=true&comments=true&key=" <> @key <> "&token=" <> @token)
      |> get()

    body = response.body
    IO.inspect(body)

    %{
      image: body["cover"]["sharedSourceUrl"],
      id: body["id"],
      name: body["name"],
      description: body["desc"]
    }
  end
end
