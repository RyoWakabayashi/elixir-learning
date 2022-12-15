defmodule ApiWeb.PingController do
  use ApiWeb, :controller

  action_fallback ApiWeb.FallbackController

  def ping(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{})
  end
end
