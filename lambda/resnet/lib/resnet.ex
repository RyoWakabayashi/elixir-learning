defmodule Resnet do
  use FaasBase, service: :aws
  alias FaasBase.Logger
  alias FaasBase.Aws.Request
  alias FaasBase.Aws.Response

  @impl FaasBase
  def init(context) do
    {:ok, context}
  end

  @impl FaasBase
  def handle(_, %{"Payload" => base64}, _) do
    predictions =
      base64
      |> Base.decode64!()
      |> predict()

    {:ok, Response.to_response(%{"predictions" => predictions}, %{}, 200)}
  end

  defp predict(binary) do
    tensor =
      binary
      |> StbImage.read_binary!()
      |> StbImage.to_nx()

    resnet = Serving.get(:resnet)

    resnet
    |> Nx.Serving.run(tensor)
    |> then(& &1.predictions)
  end
end
