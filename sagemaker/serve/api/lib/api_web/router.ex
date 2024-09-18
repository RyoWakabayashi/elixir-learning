defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json", "jpg", "jpeg", "png"]
  end

  scope "/", ApiWeb do
    pipe_through(:api)
    get "/ping", PingController, :ping
    post "/invocations", PredictionController, :index
  end
end
