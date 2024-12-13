defmodule KsphoenixWeb.PageController do
  use KsphoenixWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
  def todolist(conn, _params) do
    render(conn, :todolist)
  end
end
