defmodule KsphoenixWeb.Router do
  use KsphoenixWeb, :router

  import KsphoenixWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {KsphoenixWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # General scope for routes that everyone can access
  scope "/", KsphoenixWeb do
    pipe_through :browser

    # Add general-purpose routes here in the future, if needed
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ksphoenix, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: KsphoenixWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication Routes

  # Routes for unauthenticated users
  scope "/", KsphoenixWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/", PageController, :home

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{KsphoenixWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

# Routes for authenticated users
scope "/", KsphoenixWeb do
  pipe_through [:browser, :require_authenticated_user]

  live_session :require_authenticated_user,
    on_mount: [{KsphoenixWeb.UserAuth, :ensure_authenticated}] do
    live "/home", HomeLive, :index
    live "/users/settings", UserSettingsLive, :edit
    live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

    # Add these routes for tasks
    live "/tasks", TaskLive.Index, :index
    live "/tasks/new", TaskLive.Index, :new
    live "/tasks/:id/edit", TaskLive.Index, :edit
    live "/tasks/:id", TaskLive.Show, :show
    live "/tasks/:id/show/edit", TaskLive.Show, :edit
  end
end


  # Routes for general purposes (e.g., logout, confirmation)
  scope "/", KsphoenixWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{KsphoenixWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
