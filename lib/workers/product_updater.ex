defmodule Emerald.Worker.ProductUpdater do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  defp schedule_work do
    Process.send_after(self(), :work, 1000) # 1 seconds
  end

  def handle_info(:work, state) do
    # Do the desired work here
    IO.puts "Hello"
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  def init(state) do
    schedule_work() # Schedule work to be performed on start
    {:ok, state}
  end
end
