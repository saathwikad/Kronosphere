defmodule KsphoenixWeb.EventLive.Index do
  use KsphoenixWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, events: [], show_modal: false, selected_date: nil)}
  end

  def handle_event("add_event", %{"title" => title, "description" => description, "date" => date}, socket) do
    new_event = %{title: title, description: description, date: date}
    events = socket.assigns.events ++ [new_event]
    {:noreply, assign(socket, events: events, show_modal: false)}
  end

  def handle_event("show_modal", %{"date" => date}, socket) do
    {:noreply, assign(socket, show_modal: true, selected_date: date)}
  end

  def handle_event("hide_modal", _params, socket) do
    {:noreply, assign(socket, show_modal: false)}
  end

  defp encode_events(events) do
    case Jason.encode(events) do
      {:ok, json} -> json
      _ -> "[]"
    end
  end
end
