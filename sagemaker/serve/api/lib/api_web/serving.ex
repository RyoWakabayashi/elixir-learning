defmodule ApiWeb.Serving do
  use Agent

  def start_link(_opts) do
    {:ok, model} =
      Bumblebee.load_model({
        :hf,
        "microsoft/resnet-50"
      })

    {:ok, featurizer} =
      Bumblebee.load_featurizer({
        :hf,
        "microsoft/resnet-50"
      })

    resnet = Bumblebee.Vision.image_classification(model, featurizer)

    # Agent に入れておく
    Agent.start_link(fn ->
      %{
        resnet: resnet,
      }
    end, name: __MODULE__)
  end

  # 使用時に Agent から取り出す
  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end
end
