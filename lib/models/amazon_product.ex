defmodule Emerald.AmazonProduct do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Emerald.Repo
  alias Emerald.AmazonProduct

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

  @all_fields [:scanned_at]

  def changeset(%AmazonProduct{} = amazon_product, attrs) do
    amazon_product
    |> cast(attrs, @all_fields)
  end

  def list_amazon_products do
    Repo.all(AmazonProduct)
  end

  def touch(%AmazonProduct{} = amazon_product) do
    amazon_product
    |> changeset(%{scanned_at: Timex.now("Europe/London")})
    |> Repo.update()
  end

  def get_amazon_product!(id), do: Repo.get!(AmazonProduct, id)

  def find_by_asin(asin) do
    case Repo.get_by(AmazonProduct, asin: asin) do
      nil -> {:error, :not_found}
      amazon_product -> {:ok, amazon_product}
    end
  end

  def all do
    query = from amazon_product in AmazonProduct
    Repo.all(query)
  end

  def one_day_old do
    query = from amazon_product in AmazonProduct,
      where: amazon_product.scanned_at <= ago(1, "day"),
      order_by: fragment("RANDOM()"),
      limit: 1
    List.first(Repo.all(query))
  end
end
