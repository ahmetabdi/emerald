defmodule Emerald.Worker.ProductUpdater do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(state) do
    schedule_work()
    # IO.puts "init/1: #{inspect(state)}"
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
    case Emerald.AmazonProduct.one_day_old do
      nil -> IO.puts IO.ANSI.green() <> "None left!" <> IO.ANSI.reset()
      amazon_product -> fetch(amazon_product, host, access_key, secret_key, affiliate_id)
    end
  end

  def fetch(amazon_product, host, access_key, secret_key, affiliate_id) do
    config = %{host: System.get_env(host), access_key: System.get_env(access_key), secret_key: System.get_env(secret_key), affiliate_id: System.get_env(affiliate_id)}
    case Emerald.Operator.item_lookup(amazon_product.asin, config) do
      {:ok, item} -> Emerald.Task.ProductHistoryCreator.run(
        amazon_product,
        Map.merge(item, %{amazon_product_id: amazon_product.id, created_at: Timex.now("Europe/London"), updated_at: Timex.now("Europe/London")})
      )
      {:throttled, message} -> IO.puts IO.ANSI.red() <> "Throttled: #{message}" <> IO.ANSI.reset()
    end
  end
end

defmodule Emerald.Task.ProductHistoryCreator do
  def run(amazon_product, attrs) do
    Emerald.AmazonProductHistory.create(attrs)
    Emerald.AmazonProduct.touch(amazon_product)
  end
end
