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

      <!-- Form for adding task -->
      <div class="task-form mb-4">
        <%= if @selected_date do %>
          <h4 class="text-lg font-semibold text-gray-700">Add Task for <%= Calendar.strftime(@selected_date, "%B %d, %Y") %></h4>
          <form phx-submit="add-task" phx-target={@myself}>
            <input type="text" name="task" class="border p-1 rounded-md" placeholder="Enter task" required />
            <button type="submit" class="ml-2 px-4 py-2 bg-blue-500 text-white rounded-md">Add Task</button>
          </form>
        <% else %>
          <p class="text-gray-500">Select a date to add a task.</p>
        <% end %>
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
              <!-- Display events for the day -->
              <div class="mt-2">
                <%= for event <- Map.get(@events, day, []) do %>
                  <div class="event text-xs text-gray-500 bg-gray-200 p-1 rounded-md">
                    <%= event %>
                  </div>
                <% end %>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  def mount(socket) do
    current_date = Date.utc_today()
    events = %{}

    assigns = [
      current_date: current_date,
      selected_date: nil,
      week_rows: week_rows(current_date),
      events: events
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("prev-month", _, socket) do
    new_date = socket.assigns.current_date |> Date.beginning_of_month() |> Date.add(-1)

    assigns = [
      current_date: new_date,
      week_rows: week_rows(new_date),
      events: socket.assigns.events
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("next-month", _, socket) do
    new_date = socket.assigns.current_date |> Date.end_of_month() |> Date.add(1)

    assigns = [
      current_date: new_date,
      week_rows: week_rows(new_date),
      events: socket.assigns.events
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("pick-date", %{"date" => date}, socket) do
    selected_date = Date.from_iso8601!(date)

    assigns = [
      current_date: socket.assigns.current_date,
      selected_date: selected_date,
      week_rows: socket.assigns.week_rows,
      events: socket.assigns.events
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("add-task", %{"task" => task}, socket) do
    if socket.assigns.selected_date do
      updated_events = Map.update(socket.assigns.events, socket.assigns.selected_date, [task], fn events -> [task | events] end)

      assigns = [
        current_date: socket.assigns.current_date,
        selected_date: socket.assigns.selected_date,
        week_rows: socket.assigns.week_rows,
        events: updated_events
      ]

      {:noreply, assign(socket, assigns)}
    else
      {:noreply, socket}
    end
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
