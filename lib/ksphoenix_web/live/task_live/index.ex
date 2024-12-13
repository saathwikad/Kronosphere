defmodule KsphoenixWeb.TaskLive.Index do
  use KsphoenixWeb, :live_view

  alias Ksphoenix.Tasks
  alias Ksphoenix.Tasks.Task

  def mount(_params, _session, socket) do
    tasks = Tasks.list_tasks()
    {:ok, assign(socket, tasks: tasks, changeset: Tasks.change_task(%Task{}))}
  end

  def handle_event("add_task", %{"task" => task_params}, socket) do
    case Tasks.create_task(task_params) do
      {:ok, _task} ->
        tasks = Tasks.list_tasks()
        {:noreply, assign(socket, tasks: tasks, changeset: Tasks.change_task(%Task{}))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("change_status", %{"id" => id, "status" => status}, socket) do
    task = Tasks.get_task!(id)
    case Tasks.update_task_status(task, status) do
      {:ok, _task} ->
        tasks = Tasks.list_tasks()
        {:noreply, assign(socket, tasks: tasks)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~L"""
    <div class="container mx-auto p-6">
      <h1 class="text-3xl font-bold mb-6 text-center">To-Do List</h1>

      <!-- Task Form -->
      <div class="bg-gray-100 p-6 rounded-lg shadow-md mb-8">
        <h2 class="text-xl font-semibold mb-4">Add a New Task</h2>
        <form phx-submit="add_task" class="grid gap-4">
          <div>
            <label class="block text-sm font-medium mb-2">Title</label>
            <input
              type="text"
              name="task[title]"
              class="w-full p-2 border rounded"
              placeholder="Task Title"
              required
            />
          </div>
          <div>
            <label class="block text-sm font-medium mb-2">Description</label>
            <textarea
              name="task[description]"
              class="w-full p-2 border rounded"
              placeholder="Task Description"
              required
            ></textarea>
          </div>
          <div>
            <label class="block text-sm font-medium mb-2">Due Date</label>
            <input
              type="date"
              name="task[due_date]"
              class="w-full p-2 border rounded"
              required
            />
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium mb-2">Status</label>
              <select name="task[status]" class="w-full p-2 border rounded">
                <option value="Pending">Pending</option>
                <option value="Completed">Completed</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium mb-2">Type</label>
              <select name="task[task_type]" class="w-full p-2 border rounded">
                <option value="Urgent & Important">Urgent & Important</option>
                <option value="Not Urgent & Important">Not Urgent & Important</option>
                <option value="Urgent & Not Important">Urgent & Not Important</option>
                <option value="Not Urgent & Not Important">Not Urgent & Not Important</option>
              </select>
            </div>
          </div>
          <button
            type="submit"
            class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600"
          >
            Add Task
          </button>
        </form>
      </div>

      <!-- Task List -->
      <div class="bg-white p-6 rounded-lg shadow-md">
        <h2 class="text-xl font-semibold mb-4">Your Tasks</h2>
        <div class="space-y-4">
          <%= for task <- @tasks do %>
            <div
              class="p-4 rounded-lg shadow flex justify-between items-start <%= get_task_color(task.task_type) %>"
            >
              <div>
                <h3 class="text-lg font-bold"><%= task.title %></h3>
                <p class="text-sm text-gray-700"><%= task.description %></p>
                <p class="text-sm text-gray-500">Due Date: <%= task.due_date %></p>
                <p class="text-sm text-gray-500">Type: <%= task.task_type %></p>
              </div>
              <div>
              <button
                phx-click="change_status"
                phx-value-id="<%= task.id %>"
                phx-value-status="<%= if task.status == "Pending", do: "Completed", else: "Pending" %>"
                class="text-sm px-4 py-2 rounded <%= if task.is_completed, do: "bg-green-500 text-white", else: if task.status == "Pending", do: "bg-green-400 text-black", else: "bg-orange-300 text-black" %>"
              >
                <%= if task.status == "Pending", do: "Completed", else: "Pending" %>
              </button>

              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp get_task_color(task_type) do
    case task_type do
      "Urgent & Important" -> "bg-red-100"
      "Not Urgent & Important" -> "bg-yellow-100"
      "Urgent & Not Important" -> "bg-blue-100"
      "Not Urgent & Not Important" -> "bg-green-100"
      _ -> "bg-gray-100"
    end
  end
end
