defmodule Emerald.Worker.ProductUpdater do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  defp schedule_work do
    Process.send_after(self(), :work, 1) # 1 seconds
  end

  def handle_info(:work, state) do
    asin = Emerald.AmazonProduct.one_day_old

    IO.puts "handle_info/2: #{inspect(Emerald.Operator.item_lookup(asin))}"
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  def terminate(_, state) do
    IO.puts "terminate/2: #{inspect(state)}"
    :normal
  end

  def init(state) do
    schedule_work() # Schedule work to be performed on start
    IO.puts "init/1: #{inspect(state)}"
    {:ok, state}
  end
end
