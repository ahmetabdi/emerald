defmodule Emerald.Worker.ProductUpdater do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(state) do
    schedule_work() # Schedule work to be performed on start
    IO.puts "init/1: #{inspect(state)}"
    {:ok, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, 1000) # 1 seconds
  end

  def handle_info(:work, state) do
    task = Task.async(Emerald.Task.ProductImporter, :run, [])
    Task.await(task)
    schedule_work() # Reschedule
    {:noreply, state}
  end
end

defmodule Emerald.Task.ProductImporter do
  def run() do
    asin = Emerald.AmazonProduct.one_day_old
    IO.puts "========================#{asin}==================================="
    case Emerald.Operator.item_lookup(asin) do
      {:ok, item} -> IO.puts IO.ANSI.green() <> inspect(item) <> IO.ANSI.reset()
      {:throttled, message} -> IO.puts IO.ANSI.red() <> "Throttled: #{message}" <> IO.ANSI.reset()
    end
  end
end
