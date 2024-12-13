defmodule KsphoenixWeb.TodoLive.Index do
  use KsphoenixWeb, :live_view

  alias Ksphoenix.Todos
  alias Ksphoenix.Todos.Todo

  def mount(_params, _session, socket) do
    todos = Todos.list_todos()
    {:ok, assign(socket, todos: todos, changeset: Todos.change_todo(%Todo{}))}
  end

  def handle_event("add_todo", %{"todo" => todo_params}, socket) do
    case Todos.create_todo(todo_params) do
      {:ok, _todo} ->
        todos = Todos.list_todos()
        {:noreply, assign(socket, todos: todos, changeset: Todos.change_todo(%Todo{}))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("change_status", %{"id" => id, "status" => status}, socket) do
    todo = Todos.get_todo!(id)
    case Todos.update_todo_status(todo, status) do
      {:ok, _todo} ->
        todos = Todos.list_todos()
        {:noreply, assign(socket, todos: todos)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_event("delete_todo", %{"id" => id}, socket) do
    case Todos.get_todo(id) do
      nil ->
        {:noreply, socket}

      todo ->
        # Delete the Todo from the database
        {:ok, _todo} = Todos.delete_todo(todo)

        # Refresh the Todo list
        todos = Todos.list_todos()
        {:noreply, assign(socket, todos: todos)}
    end
  end

  def render(assigns) do
    ~L"""
    <div class="container mx-auto p-6">
      <h1 class="text-3xl font-bold mb-6 text-center">To-Do List</h1>

      <!-- Todo Form -->
      <div class="bg-gray-100 p-6 rounded-lg shadow-md mb-8">
        <h2 class="text-xl font-semibold mb-4">Add a New Todo</h2>
        <form phx-submit="add_todo" class="grid gap-4">
          <div>
            <label class="block text-sm font-medium mb-2">Title</label>
            <input
              type="text"
              name="todo[title]"
              class="w-full p-2 border rounded"
              placeholder="Todo Title"
              required
            />
          </div>
          <div>
            <label class="block text-sm font-medium mb-2">Description</label>
            <textarea
              name="todo[description]"
              class="w-full p-2 border rounded"
              placeholder="Todo Description"
              required
            ></textarea>
          </div>
          <div>
            <label class="block text-sm font-medium mb-2">Due Date</label>
            <input
              type="date"
              name="todo[due_date]"
              class="w-full p-2 border rounded"
              required
            />
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium mb-2">Status</label>
              <select name="todo[status]" class="w-full p-2 border rounded">
                <option value="Pending">Pending</option>
                <option value="Completed">Completed</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium mb-2">Type</label>
              <select name="todo[task_type]" class="w-full p-2 border rounded">
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
            Add Todo
          </button>
        </form>
      </div>

      <!-- Todo List -->
      <div class="bg-white p-6 rounded-lg shadow-md">
        <h2 class="text-xl font-semibold mb-4">Your Todos</h2>
        <div class="space-y-4">
          <%= for todo <- @todos do %>
            <div
              class="p-4 rounded-lg shadow flex justify-between items-start <%= get_todo_color(todo.task_type) %>"
            >
              <div>
                <h3 class="text-lg font-bold"><%= todo.title %></h3>
                <p class="text-sm text-gray-700"><%= todo.description %></p>
                <p class="text-sm text-gray-500">Due Date: <%= todo.due_date %></p>
                <p class="text-sm text-gray-500">Type: <%= todo.task_type %></p>
              </div>
              <div>
                <button
                  phx-click="change_status"
                  phx-value-id="<%= todo.id %>"
                  phx-value-status="<%= if todo.status == "Pending", do: "Completed", else: "Pending" %>"
                  class="text-sm px-4 py-2 rounded <%= if todo.is_completed, do: "bg-blue-500 text-white", else: "bg-gray-300 text-black" %>"
                >
                  <%= if todo.status == "Pending", do: "Complete", else: "Pending" %>
                </button>

                <!-- Delete Button -->
                <button
                  phx-click="delete_todo"
                  phx-value-id="<%= todo.id %>"
                  class="text-sm px-4 py-2 rounded bg-red-500 text-white hover:bg-red-600"
                >
                  Delete
                </button>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp get_todo_color(task_type) do
    case task_type do
      "Urgent & Important" -> "bg-red-100"
      "Not Urgent & Important" -> "bg-yellow-100"
      "Urgent & Not Important" -> "bg-blue-100"
      "Not Urgent & Not Important" -> "bg-green-100"
      _ -> "bg-gray-100"
    end
  end
end
