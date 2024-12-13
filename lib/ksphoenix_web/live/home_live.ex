defmodule KsphoenixWeb.HomeLive do
  use KsphoenixWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-3xl mb-6 text-center"></h1>
    
    <div style="display: flex; flex-direction: column; gap: 30px; width: 100%; padding: 40px; margin-top: 20px;">
      <.link navigate={~p"/tasks"} class="button" style="display: flex; justify-content: space-between; align-items: center; background-color: #3498db; color: white; padding: 40px; font-size: 28px; text-align: center; border-radius: 12px; transition: background-color 0.3s ease; cursor: pointer; text-decoration: none; font-weight: bold; position: relative;">
        <span>Block 1</span>
        <span style="font-size: 24px; animation: arrow 1s infinite; margin-left: 15px;">→</span>
      </.link>

      <a href="#" style="display: flex; justify-content: space-between; align-items: center; background-color: #3498db; color: white; padding: 40px; font-size: 28px; text-align: center; border-radius: 12px; transition: background-color 0.3s ease; cursor: pointer; text-decoration: none; font-weight: bold; position: relative;">
        <span>Block 2</span>
        <span style="font-size: 24px; animation: arrow 1s infinite; margin-left: 15px;">→</span>
      </a>

      <a href="#" style="display: flex; justify-content: space-between; align-items: center; background-color: #3498db; color: white; padding: 40px; font-size: 28px; text-align: center; border-radius: 12px; transition: background-color 0.3s ease; cursor: pointer; text-decoration: none; font-weight: bold; position: relative;">
        <span>Block 3</span>
        <span style="font-size: 24px; animation: arrow 1s infinite; margin-left: 15px;">→</span>
      </a>

      <a href="#" style="display: flex; justify-content: space-between; align-items: center; background-color: #3498db; color: white; padding: 40px; font-size: 28px; text-align: center; border-radius: 12px; transition: background-color 0.3s ease; cursor: pointer; text-decoration: none; font-weight: bold; position: relative;">
        <span>Block 4</span>
        <span style="font-size: 24px; animation: arrow 1s infinite; margin-left: 15px;">→</span>
      </a>
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
