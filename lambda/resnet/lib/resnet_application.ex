defmodule ResnetApplication do
  use Application

  alias FaasBase.Aws.Logger
  alias FaasBase.Aws.BaseTask

  @doc """
  Start Application.
  """
  def start(_type, _args) do
    context = System.get_env()

    children = [
      Serving,
      {Logger, context |> Map.get("LOG_LEVEL", "INFO") |> String.downcase() |> String.to_atom()},
      {FaasBase.Logger, Logger},
      {BaseTask, context}
    ]

    Supervisor.start_link(children, strategy: :one_for_all)
  end
end
