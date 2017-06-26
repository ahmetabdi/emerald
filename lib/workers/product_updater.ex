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
    task1 = Task.async(Emerald.Task.ProductImporter, :run, ["AMAZON_HOST_1", "AMAZON_ACCESS_KEY_ID_1", "AMAZON_SECRET_KEY_1", "AMAZON_AFFILIATE_ID_1"])
    task2 = Task.async(Emerald.Task.ProductImporter, :run, ["AMAZON_HOST_2", "AMAZON_ACCESS_KEY_ID_2", "AMAZON_SECRET_KEY_2", "AMAZON_AFFILIATE_ID_2"])
    task3 = Task.async(Emerald.Task.ProductImporter, :run, ["AMAZON_HOST_3", "AMAZON_ACCESS_KEY_ID_3", "AMAZON_SECRET_KEY_3", "AMAZON_AFFILIATE_ID_3"])
    task4 = Task.async(Emerald.Task.ProductImporter, :run, ["AMAZON_HOST_4", "AMAZON_ACCESS_KEY_ID_4", "AMAZON_SECRET_KEY_4", "AMAZON_AFFILIATE_ID_4"])
    Task.await(task1)
    Task.await(task2)
    Task.await(task3)
    Task.await(task4)
    schedule_work() # Reschedule
    {:noreply, state}
  end
end

defmodule Emerald.Task.ProductImporter do
  def run(host, access_key, secret_key, affiliate_id) do
    asin = Emerald.AmazonProduct.one_day_old
    config = %{host: System.get_env(host), access_key: System.get_env(access_key), secret_key: System.get_env(secret_key), affiliate_id: System.get_env(affiliate_id)}
    IO.puts "========================#{asin}==================================="
    case Emerald.Operator.item_lookup(asin, config) do
      {:ok, item} -> IO.puts IO.ANSI.green() <> inspect(item) <> IO.ANSI.reset()
      {:throttled, message} -> IO.puts IO.ANSI.red() <> "Throttled: #{message}" <> IO.ANSI.reset()
    end
  end
end
