defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(CORSPlug, origin: ["*"])
  end

  scope "/api", TimemanagerWeb do
    pipe_through(:api)

    get("/users", UserController, :index)
    get("/users/:userID", UserController, :show)
    post("/users", UserController, :create)
    put("/users/:userID", UserController, :update)
    delete("/users/usersID", UserController, :delete)

    get("/clocks/:userID", ClockController, :index)
    post("/clocks/:userID", ClockController, :create)

    get("/workingtime/:userID", WorkingTimeController, :index)
    get("/workingtime/:userID/:id", WorkingTimeController, :show)
    post("/workingtime/:userID", WorkingTimeController, :create)
    put("/workingtime/:id", WorkingTimeController, :update)
    delete("/workingtime/:id", WorkingTimeController, :delete)
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:time_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: TimemanagerWeb.Telemetry)
    end
  end
end
