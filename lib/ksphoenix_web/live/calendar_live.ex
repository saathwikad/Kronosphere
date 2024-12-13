defmodule KsphoenixWeb.Live.CalendarLive do
  use Phoenix.LiveView

  alias KsphoenixWeb.Live.CalendarComponent

  def render(assigns) do
    ~H"""
    <.live_component module={CalendarComponent} id="calendar" />
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
