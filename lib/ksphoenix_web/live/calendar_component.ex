defmodule KsphoenixWeb.Live.CalendarComponent do
  use Phoenix.LiveComponent

  @week_start_at :monday

  def render(assigns) do
    ~H"""
    <div class="calendar-component p-4 border rounded-md shadow-md bg-white">
      <div class="calendar-header flex justify-between items-center mb-4">
        <h3 class="text-xl font-semibold text-gray-700"><%= Calendar.strftime(@current_date, "%B %Y") %></h3>
        <div class="button-group flex gap-2">
          <button type="button"
                  phx-target={@myself}
                  phx-click="prev-month"
                  class="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-lg text-gray-700">
            &laquo; Prev
          </button>
          <button type="button"
                  phx-target={@myself}
                  phx-click="next-month"
                  class="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-lg text-gray-700">
            Next &raquo;
          </button>
        </div>
      </div>

      <table class="calendar-table w-full border-collapse text-center">
        <thead>
          <tr class="bg-gray-100">
            <th :for={week_day <- List.first(@week_rows)} class="py-2 text-gray-600 font-medium">
              <%= Calendar.strftime(week_day, "%a") %>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr :for={week <- @week_rows}>
            <td :for={day <- week} class={[
              "py-2 border border-gray-200",
              today?(day) && "bg-green-100 font-semibold",
              other_month?(day, @current_date) && "bg-gray-100 text-gray-400",
              selected_date?(day, @selected_date) && "bg-blue-100 font-semibold text-blue-700"
            ]}>
              <button type="button"
                      phx-target={@myself}
                      phx-click="pick-date"
                      phx-value-date={Calendar.strftime(day, "%Y-%m-%d")}
                      class="w-full h-full p-1 hover:bg-blue-200 focus:outline-none rounded">
                <time datetime={Calendar.strftime(day, "%Y-%m-%d")} class="block">
                  <%= Calendar.strftime(day, "%d") %>
                </time>
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  def mount(socket) do
    current_date = Date.utc_today()

    assigns = [
      current_date: current_date,
      selected_date: nil,
      week_rows: week_rows(current_date)
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("prev-month", _, socket) do
    new_date = socket.assigns.current_date |> Date.beginning_of_month() |> Date.add(-1)

    assigns = [
      current_date: new_date,
      week_rows: week_rows(new_date)
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("next-month", _, socket) do
    new_date = socket.assigns.current_date |> Date.end_of_month() |> Date.add(1)

    assigns = [
      current_date: new_date,
      week_rows: week_rows(new_date)
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("pick-date", %{"date" => date}, socket) do
    {:noreply, assign(socket, :selected_date, Date.from_iso8601!(date))}
  end

  defp week_rows(current_date) do
    first =
      current_date
      |> Date.beginning_of_month()
      |> Date.beginning_of_week(@week_start_at)

    last =
      current_date
      |> Date.end_of_month()
      |> Date.end_of_week(@week_start_at)

    Date.range(first, last)
    |> Enum.map(& &1)
    |> Enum.chunk_every(7)
  end

  defp selected_date?(day, selected_date), do: day == selected_date

  defp today?(day), do: day == Date.utc_today()

  defp other_month?(day, current_date), do: Date.beginning_of_month(day) != Date.beginning_of_month(current_date)
end
