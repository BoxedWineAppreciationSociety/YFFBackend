defmodule YFFBackendWeb.Router do
  use YFFBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", YFFBackendWeb do
    pipe_through :api

    resources "/artists", ArtistController, only: [:index, :show]
  end
end
