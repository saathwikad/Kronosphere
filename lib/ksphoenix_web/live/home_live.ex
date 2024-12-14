defmodule KsphoenixWeb.HomeLive do
  use KsphoenixWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-3xl mb-6 text-center"></h1>

    <div style="display: flex; flex-direction: column; gap: 30px; width: 100%; padding: 40px; margin-top: 20px;">
      <.link navigate={~p"/timer"} class="button" style="display: flex; justify-content: space-between; align-items: center; background-color: #2d1309; color: white; padding: 40px; font-size: 28px; text-align: center; border-radius: 12px; transition: background-color 0.3s ease; cursor: pointer; text-decoration: none; font-weight: bold; position: relative;">
        <span>Pomodoro</span>
        <span style="font-size: 24px; animation: arrow 1s infinite; margin-left: 15px;">→</span>
      </.link>

    <.link navigate={~p"/calendar"} class="button" style="display: flex; justify-content: space-between; align-items: center; background-color: #5f3b24; color: white; padding: 40px; font-size: 28px; text-align: center; border-radius: 12px; transition: background-color 0.3s ease; cursor: pointer; text-decoration: none; font-weight: bold; position: relative;">
      <span>The Event Calendar</span>
      <span style="font-size: 24px; animation: arrow 1s infinite; margin-left: 15px;">→</span>
    </.link>

    <.link navigate={~p"/canvas"} class="button" style="display: flex; justify-content: space-between; align-items: center; background-color: #a17e65; color: white; padding: 40px; font-size: 28px; text-align: center; border-radius: 12px; transition: background-color 0.3s ease; cursor: pointer; text-decoration: none; font-weight: bold; position: relative;">
      <span>The Playaround</span>
      <span style="font-size: 24px; animation: arrow 1s infinite; margin-left: 15px;">→</span>
    </.link>

    <.link navigate={~p"/todos"} class="button" style="display: flex; justify-content: space-between; align-items: center; background-color: #a79a95; color: white; padding: 40px; font-size: 28px; text-align: center; border-radius: 12px; transition: background-color 0.3s ease; cursor: pointer; text-decoration: none; font-weight: bold; position: relative;">
      <span>Eisenhower Matrix</span>
      <span style="font-size: 24px; animation: arrow 1s infinite; margin-left: 15px;">→</span>
    </.link>

    <.link navigate={~p"/posts"} class="button" style="display: flex; justify-content: space-between; align-items: center; background-color: #cbbcaf; color: white; padding: 40px; font-size: 28px; text-align: center; border-radius: 12px; transition: background-color 0.3s ease; cursor: pointer; text-decoration: none; font-weight: bold; position: relative;">
      <span>Post-It's</span>
      <span style="font-size: 24px; animation: arrow 1s infinite; margin-left: 15px;">→</span>
    </.link>

    </div>

    <style>
      a:hover {
        background-color: #2980b9;
      }

      a:active {
        background-color: #1f6691;
      }

      @keyframes arrow {
        0% {
          transform: translateX(0);
        }
        50% {
          transform: translateX(10px);
        }
        100% {
          transform: translateX(0);
        }
      }
    </style>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
