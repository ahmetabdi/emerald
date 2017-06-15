defmodule Emerald.AmazonProduct do
  use Ecto.Schema
  import Ecto.Query

  @primary_key {:id, :id, autogenerate: true}

  schema "amazon_products" do
    has_many :amazon_product_histories, AmazonProductHistory

    field :title, :string
    field :manufacturer, :string
    field :brand, :string
    field :product_type_name, :string
    field :model, :string
    field :ean, :string
    field :upc, :string
    field :asin, :string
    field :parent_asin, :string
    field :detail_page_url, :string
    field :add_to_wishlist_url, :string
    field :tell_a_friend_url, :string
    field :customer_reviews_url, :string
    field :all_offers_url, :string
    field :part_number, :string
    field :size_of_item, :string
    field :studio, :string
    field :main_large_image, :string
    field :main_medium_image, :string
    field :main_small_image, :string
    field :slug, :string

    field :variant_large_images, {:array, :string}
    field :variant_medium_images, {:array, :string}
    field :variant_small_images, {:array, :string}
    field :similar_products, {:array, :string}
    field :tags, {:array, :string}
    field :features, {:array, :string}

    field :current_price, :integer
    field :current_sales_rank, :integer
    field :total_new, :integer
    field :total_used, :integer
    field :total_collectible, :integer
    field :total_refurbished, :integer
    field :package_quantity, :integer
    field :percentage_to_save, :integer, default: 0

    field :amazon_product_group_id, :integer
    field :amazon_product_category_id, :integer

    field :current_prime, :boolean, default: false
    field :current_super_saver, :boolean, default: false
    field :adult_product, :boolean, default: false

    field :scanned_at, :naive_datetime
    field :created_at, :naive_datetime, null: false
    field :updated_at, :naive_datetime, null: false
  end

  def all do
    query = from amazon_product in Emerald.AmazonProduct
    Emerald.Repo.all(query)
  end

  def one_day_old do
    query = from amazon_product in Emerald.AmazonProduct,
      where: amazon_product.scanned_at <= ago(1, "day"),
      select: amazon_product.asin,
      order_by: fragment("RANDOM()"),
      limit: 1
    List.first(Emerald.Repo.all(query))
  end
end
