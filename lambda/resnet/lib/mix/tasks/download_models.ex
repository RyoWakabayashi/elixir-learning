defmodule Mix.Tasks.DownloadModels do
  @moduledoc "Download ResNet models"
  use Mix.Task

  @shortdoc "Download ResNet models."
  def run(_) do
    Serving.load_model()
  end
end
