defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug :fetch_api_user
  end

  pipeline :auth do
    plug :fetch_api_user
  end

  pipeline :admin do
    plug TimemanagerWeb.EnsureRole, :admin
  end

  pipeline :manager_or_admin do
    plug TimemanagerWeb.EnsureRole, [:admin, :manager]
  end

  pipeline :verify_user do
    plug :ensure_self
  end

  def ensure_self(conn, _opts) do

    user_id = String.to_integer(conn.params["userID"])
    current_user = conn.assigns[:current_user]

    IO.puts("User ID: #{user_id}, Current user ID: #{current_user.id}; User Role: #{current_user.role}")
    IO.puts("Result: #{(current_user.id == user_id) || (current_user.role == "admin")}")
    case current_user.id == user_id || current_user.role == "admin" do
      true ->
      conn
      false ->
      unauthorized(conn)
    end
  end



  def fetch_api_user(conn, _opts) do
    IO.puts("Received token: #{inspect(get_req_header(conn, "authorization"))}")
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        clean_token = String.trim(token, "\"")
        case Timemanager.Accounts.fetch_user_by_api_token(clean_token) do
          {:ok, user} ->
            IO.puts("User role: #{user.role}")
            assign(conn, :current_user, user)
          _ -> unauthorized(conn)
        end
      _ ->
        unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    TimemanagerWeb.AuthErrorHandler.auth_error(conn, {:unauthorized, "No valid token"}, [])
  end

  # Routes publiques ne nécessitant pas d'authentification
  scope "/api", TimemanagerWeb do
    pipe_through :api

    post "/register", AuthController, :register
    post "/login", AuthController, :login
  end

  # Routes nécessitant une authentification API
  scope "/api", TimemanagerWeb do
    pipe_through [:api_auth]

    post "/logout", AuthController, :logout
    get "/me", AuthController, :me
    post "/refresh", AuthController, :refresh
    put "/change-password", AuthController, :change_password

    # Routes accessibles à tous les utilisateurs authentifiés
    get "/clocks/:userID", ClockController, :index
    get "/workingtime/:start/:end", WorkingTimeController, :getAllIndex
    get "/workingtime/:userID", WorkingTimeController, :indexId
    get "/workingtime/:userID/:id", WorkingTimeController, :show
    post "/workingtime/:userID", WorkingTimeController, :create
    put "/workingtime/:id", WorkingTimeController, :update
    delete "/workingtime/:id", WorkingTimeController, :delete
  end

  # Routes accessibles seulement a l'utilisateur concerné par la manipulation (ou un admin)
  scope "/api", TimemanagerWeb do
    pipe_through [:api_auth, :verify_user]

    post "/clocks/:userID", ClockController, :create

  end

  # Routes accessibles aux managers et admins
  scope "/api", TimemanagerWeb do
    pipe_through [:api_auth, :manager_or_admin]

    get "/users", UserController, :index
    get "/users/:userID", UserController, :show
  end

  # Routes accessibles uniquement aux admins
  scope "/api", TimemanagerWeb do
    pipe_through [:api_auth, :admin]

    post "/users", UserController, :create
    put "/users/:userID", UserController, :update
    delete "/users/:userID", UserController, :delete
  end

  # Route spécifique pour la mise à jour des rôles (admin seulement)
  scope "/api", TimemanagerWeb do
    pipe_through [:api_auth, :admin]
    put "/users/:userID/role", UserController, :update_role
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:time_manager, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimemanagerWeb.Telemetry
    end
  end
end
