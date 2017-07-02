defmodule Emerald.AmazonProductHistory do
  use Ecto.Schema
  import Ecto.Changeset
  alias Emerald.Repo
  alias Emerald.AmazonProduct
  alias Emerald.AmazonProductHistory

  @primary_key {:id, :id, autogenerate: true}

  schema "amazon_product_histories" do
    belongs_to :amazon_product, AmazonProduct

    field :availability, :string
    field :condition, :string
    field :currency_code, :string

    field :prime, :boolean, default: false
    field :super_saver, :boolean, default: false

    field :price, :integer
    field :sales_rank, :integer
    field :total_new, :integer
    field :total_used, :integer
    field :total_collectible, :integer
    field :total_refurbished, :integer

    field :created_at, :naive_datetime, null: false
    field :updated_at, :naive_datetime, null: false
  end

  @all_fields [:availability, :condition, :currency_code, :price, :prime,
   :sales_rank, :super_saver, :total_collectible, :total_new,
   :total_refurbished, :total_used, :amazon_product_id, :created_at, :updated_at]

  def changeset(%AmazonProductHistory{} = amazon_product_history, attrs) do
    amazon_product_history
    |> cast(attrs, @all_fields)
  end

  def create(attrs \\ %{}) do
    %AmazonProductHistory{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
