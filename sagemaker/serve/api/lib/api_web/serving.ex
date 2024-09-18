defmodule ApiWeb.Serving do
  @moduledoc """
  Serving.
  """

  use Agent

  @resnet_id "microsoft/resnet-50"
  @cache_dir "/opt/ml/model"

  def start_link(_opts) do
    {:ok, model} =
      Bumblebee.load_model({:hf, @resnet_id, cache_dir: @cache_dir})

    {:ok, featurizer} =
      Bumblebee.load_featurizer({:hf, @resnet_id, cache_dir: @cache_dir})

    resnet = Bumblebee.Vision.image_classification(model, featurizer)

    # Agent に入れておく
    Agent.start_link(
      fn ->
        %{
          resnet: resnet
        }
      end,
      name: __MODULE__
    )
  end

  # 使用時に Agent から取り出す
  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end
end
