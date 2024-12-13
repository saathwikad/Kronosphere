defmodule KsphoenixWeb.TimerLive do
  use KsphoenixWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       time_left: 1500,
       timer_running: false,
       timer_mode: :pomodoro,
       alarm_triggered: false
     )}
  end

  def handle_info(:tick, socket) do
    if socket.assigns.timer_running and socket.assigns.time_left > 0 do
      Process.send_after(self(), :tick, 1000)

      # Trigger alarm 3 seconds before time runs out
      if socket.assigns.time_left <= 5 and not socket.assigns.alarm_triggered do
        send(self(), :play_alarm)
        {:noreply,
         assign(socket,
           time_left: socket.assigns.time_left - 1,
           alarm_triggered: true
         )}
      else
        {:noreply, assign(socket, time_left: socket.assigns.time_left - 1)}
      end
    else
      if socket.assigns.time_left == 0 do
        # Reset the timer and stop the countdown
        {:noreply,
         assign(socket,
           time_left: timer_duration(socket.assigns.timer_mode),
           timer_running: false,
           alarm_triggered: false
         )}
      else
        {:noreply, socket}
      end
    end
  end

  def handle_info(:play_alarm, socket) do
    {:noreply, push_event(socket, "play_alarm", %{})}
  end

  def handle_event("start_timer", _params, socket) do
    if socket.assigns.timer_running do
      {:noreply, assign(socket, timer_running: false)}
    else
      send(self(), :tick)
      {:noreply,
       assign(socket,
         timer_running: true,
         alarm_triggered: false
       )}
    end
  end

  def handle_event("switch_mode", %{"mode" => mode}, socket) do
    new_mode = String.to_atom(mode)

    {:noreply,
     assign(socket,
       timer_mode: new_mode,
       time_left: timer_duration(new_mode),
       timer_running: false,
       alarm_triggered: false
     )}
  end

  defp timer_duration(:pomodoro), do: 1500
  defp timer_duration(:short_break), do: 300
  defp timer_duration(:long_break), do: 900

  def render(assigns) do
    ~H"""
    <style>
    body {
  background-color: rgba(97, 185, 243, 0.9) !important; /* Dark blue color */
  font-family: Arial, sans-serif;
  margin: 0;
  padding: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}



      .main-block {
        background-color: rgba(136, 205, 250, 0.9);
        padding: 40px;
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        width: 90%;
        max-width: 600px;
        text-align: center;
      }

      #timer p {
        font-size: 3em;
        margin: 20px 0;
      }

      .start-stop-btn {
        padding: 15px 30px;
        font-size: 1.2em;
        color: white;
        background-color: #007bff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        margin-top: 20px;
      }

      .mode-buttons {
        margin-bottom: 30px;
        display: flex;
        justify-content: space-around;
      }

      .mode-btn {
        padding: 5px 20px;
        margin: 5px;
        font-size: 1.2em;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        width: 120px;
      }

      .mode-btn.green {
        background-color: #28a745;
      }

      .mode-btn.yellow {
        background-color: #ffc107;
      }

      .mode-btn.blue {
        background-color: #17a2b8;
      }
    </style>

    <div class="container">
      <div class="main-block">
        <div class="mode-buttons">
          <button phx-click="switch_mode" phx-value-mode="pomodoro" class="mode-btn green">
            Pomodoro
          </button>
          <button phx-click="switch_mode" phx-value-mode="short_break" class="mode-btn yellow">
            Short Break
          </button>
          <button phx-click="switch_mode" phx-value-mode="long_break" class="mode-btn blue">
            Long Break
          </button>
        </div>

        <div id="timer">
          <p><strong><%= format_time(@time_left) %></strong></p>
          <button phx-click="start_timer" class="start-stop-btn">
            <%= if @timer_running, do: "Pause", else: "Start" %>
          </button>
        </div>

        <!-- Hidden audio element for alarm -->
        <audio id="alarm-sound" src="/audio/timertone1.mp3" preload="auto"></audio>
      </div>
    </div>

    <script>
      window.addEventListener("phx:play_alarm", () => {
        const alarmSound = document.getElementById("alarm-sound");
        if (alarmSound) {
          alarmSound.play();
        }
      });
    </script>
    """
  end

  defp format_time(seconds) do
    minutes = div(seconds, 60)
    seconds = rem(seconds, 60)
    "#{String.pad_leading(Integer.to_string(minutes), 2, "0")}:#{String.pad_leading(Integer.to_string(seconds), 2, "0")}"
  end
end
