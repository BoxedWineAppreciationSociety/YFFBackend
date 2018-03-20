defmodule YFFBackend.Application do
  @moduledoc """
  The YFFBackend Application Service.

  The yff_backend system business domain lives in this application.

  Exposes API to clients such as the `YFFBackendWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(YFFBackend.Repo, []),
    ], strategy: :one_for_one, name: YFFBackend.Supervisor)
  end
end
