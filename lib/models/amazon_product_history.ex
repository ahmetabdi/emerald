defmodule Emerald.AmazonProductHistory do
  use Ecto.Schema
  import Ecto.Query

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
end
