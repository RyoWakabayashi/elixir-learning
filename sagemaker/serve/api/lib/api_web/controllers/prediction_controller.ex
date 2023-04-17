defmodule ApiWeb.PredictionController do
  use ApiWeb, :controller

  alias ApiWeb.Serving

  action_fallback ApiWeb.FallbackController

  def index(conn, %{"image" => base64}) do
    predictions =
      base64
      |> Base.decode64!()
      |> predict()

    conn
    |> put_status(200)
    |> json(%{"predictions" => predictions})
  end

  def index(conn, %{}) do
    {:ok, binary, _} = Plug.Conn.read_body(conn)

    predictions = predict(binary)

    conn
    |> put_status(200)
    |> json(%{"predictions" => predictions})
  end

  defp predict(binary) do
    tensor =
      binary
      |> StbImage.read_binary!()
      |> StbImage.to_nx()

    resnet = Serving.get(:resnet)

    resnet
    |> Nx.Serving.run(tensor)
    |> Map.get(:predictions)
  end
end
