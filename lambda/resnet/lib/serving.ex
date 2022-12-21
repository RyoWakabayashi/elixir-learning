defmodule Serving do
  use Agent

  @resnet_id "microsoft/resnet-50"
  @cache_dir "/opt/ml/model"

  def start_link(_opts) do
    {model, featurizer} = load_model()

    resnet =
      Bumblebee.Vision.image_classification(
        model,
        featurizer,
        defn_options: [compiler: EXLA]
      )

    Agent.start_link(fn ->
      %{resnet: resnet}
    end, name: __MODULE__)
  end

  def load_model() do
    {:ok, model} =
      Bumblebee.load_model({:hf, @resnet_id, cache_dir: @cache_dir})

    {:ok, featurizer} =
      Bumblebee.load_featurizer({:hf, @resnet_id, cache_dir: @cache_dir})

    {model, featurizer}
  end

  # 使用時に Agent から取り出す
  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end
end
