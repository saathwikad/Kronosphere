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
      {:ok, task} ->
        tasks = Tasks.list_tasks()
        {:noreply, assign(socket, tasks: tasks, changeset: Tasks.change_task(%Task{}))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("change_status", %{"id" => id, "status" => status}, socket) do
    task = Tasks.get_task!(id)
    case Tasks.update_task_status(task, status) do
      {:ok, task} ->
        tasks = Tasks.list_tasks()
        {:noreply, assign(socket, tasks: tasks)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~L"""
    <div>
      <h1>To-Do List</h1>

      <form phx-change="add_task">
        <input type="text" name="task[title]" placeholder="Title" required>
        <textarea name="task[description]" placeholder="Description" required></textarea>
        <input type="date" name="task[due_date]" required>
        <select name="task[status]">
          <option value="Pending">Pending</option>
          <option value="Completed">Completed</option>
        </select>
        <select name="task[task_type]">
          <option value="Urgent & Important">Urgent & Important</option>
          <option value="Not Urgent & Important">Not Urgent & Important</option>
          <option value="Urgent & Not Important">Urgent & Not Important</option>
          <option value="Not Urgent & Not Important">Not Urgent & Not Important</option>
        </select>
        <button type="submit">Add Task</button>
      </form>

      <div>
        <%= for task <- @tasks do %>
          <div class="task <%= if task.is_completed, do: "completed", else: "pending" %>">
            <h3><%= task.title %></h3>
            <p><%= task.description %></p>
            <p>Due Date: <%= task.due_date %></p>
            <p>Status: <%= task.status %></p>
            <p>Type: <%= task.task_type %></p>
            <button phx-click="change_status" phx-value-id="<%= task.id %>" phx-value-status="Completed">Complete</button>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
