defmodule ApiWeb.PingController do
  use ApiWeb, :controller

  def ping(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{})
  end
end
