defmodule Emerald.Parsers.ItemLookup do
  import SweetXml

  def parse(doc) do
    %{
      # title: title(doc),
      # product_group: product_group(doc),
      # manufacturer: manufacturer(doc),
      # brand: brand(doc),
      # features: features(doc),
      # product_type_name: product_type_name(doc),
      # binding_name: binding_name(doc),
      # adult_product: adult_product(doc),
      # model: model(doc),
      # ean: ean(doc),
      # upc: upc(doc),
      # studio: studio(doc),
      # size_of_item: size_of_item(doc),
      # total_new: total_new(doc),
      # total_used: total_used(doc),
      # total_collectible: total_collectible(doc),
      # total_refurbished: total_refurbished(doc),
      # package_quantity: package_quantity(doc),
      # part_number: part_number(doc),
      # asin: asin(doc),
      # parent_asin: parent_asin(doc),
      # detail_page_url: detail_page_url(doc),
      # sales_rank: sales_rank(doc),
      # main_image: main_image(doc),
      # variant_images: variant_images(doc),
      # add_to_wishlist_url: add_to_wishlist_url(doc),
      # tell_a_friend_url: tell_a_friend_url(doc),
      # customer_reviews_url: customer_reviews_url(doc),
      # all_offers_url: all_offers_url(doc),
      # similar_products: similar_products(doc),
      # tags: tags(doc),
      list_price: list_price(doc)
    }
  end

  defp main_image(doc) do
    %{
      small: xpath(doc, ~x"#{item_path()}/SmallImage/URL/text()"),
      medium: xpath(doc, ~x"#{item_path()}/MediumImage/URL/text()"),
      large: xpath(doc, ~x"#{item_path()}/LargeImage/URL/text()")
    }
  end

  defp variant_images(doc) do
    doc
    |> xpath(~x"#{item_path()}/ImageSets/ImageSet"l)
    |> Enum.map(fn(node) ->
      %{
        swatch: node |> xpath(~x"./SwatchImage/URL/text()"),
        small: node |> xpath(~x"./SmallImage/URL/text()"),
        thumbnail: node |> xpath(~x"./ThumbnailImage/URL/text()"),
        tiny: node |> xpath(~x"./TinyImage/URL/text()"),
        medium: node |> xpath(~x"./MediumImage/URL/text()"),
        large: node |> xpath(~x"./LargeImage/URL/text()"),
      }
    end)
  end

  defp add_to_wishlist_url(doc), do: xpath(doc, ~x"#{item_path()}/ItemLinks/ItemLink"l) |> grab_text(0)
  defp tell_a_friend_url(doc), do: xpath(doc, ~x"#{item_path()}/ItemLinks/ItemLink"l) |> grab_text(1)
  defp customer_reviews_url(doc), do: xpath(doc, ~x"#{item_path()}/ItemLinks/ItemLink"l) |> grab_text(2)
  defp all_offers_url(doc), do: xpath(doc, ~x"#{item_path()}/ItemLinks/ItemLink"l) |> grab_text(3)

  defp grab_text(nil, _), do: ""
  defp grab_text(doc, number) do
    doc |> Enum.at(number) |> xpath(~x"./URL/text()")
  end

  defp list_price(doc) do
    doc |> xpath(~x"#{item_path()}/Offers/Offer") |> price
  end

  def price(nil) do
    %{

    }
  end

  def price(offer) do
    price = xpath(offer, ~x"./OfferListing/Price")
    %{
      amount: xpath(price, ~x"./Amount/text()"),
      currency_code: xpath(price, ~x"./CurrencyCode/text()"),
      condition: xpath(offer, ~x"./OfferAttributes/Condition/text()"),
      availability: xpath(offer, ~x"./OfferListing/Availability/text()"),
      super_saver: xpath(offer, ~x"./OfferListing/IsEligibleForSuperSaverShipping/text()"),
      prime: xpath(offer, ~x"./OfferListing/IsEligibleForPrime/text()")
    }
  end

  defp similar_products(doc) do
    doc
    |> xpath(~x"#{item_path()}/SimilarProducts/SimilarProduct"l)
    |> Enum.map(fn(node) -> node |> xpath(~x"./ASIN/text()") end)
  end

  defp tags(doc) do
    doc
    |> xpath(~x"#{item_path()}/BrowseNodes/BrowseNode"l)
    |> Enum.map(fn(node) -> node |> xpath(~x"./Name/text()") end)
  end

  defp title(doc), do: xpath(doc, ~x"#{attr_path()}/Title/text()")
  defp product_group(doc), do: xpath(doc, ~x"#{attr_path()}/ProductGroup/text()")
  defp manufacturer(doc), do: xpath(doc, ~x"#{attr_path()}/Manufacturer/text()")
  defp brand(doc), do: xpath(doc, ~x"#{attr_path()}/Brand/text()")
  defp features(doc), do: xpath(doc, ~x"#{attr_path()}/Feature/text()")
  defp product_type_name(doc), do: xpath(doc, ~x"#{attr_path()}/ProductTypeName/text()")
  defp binding_name(doc), do: xpath(doc, ~x"#{attr_path()}/Binding/text()")
  defp adult_product(doc), do: xpath(doc, ~x"#{attr_path()}/IsAdultProduct/text()")
  defp model(doc), do: xpath(doc, ~x"#{attr_path()}/model/text()")
  defp ean(doc), do: xpath(doc, ~x"#{attr_path()}/ean/text()")
  defp upc(doc), do: xpath(doc, ~x"#{attr_path()}/upc/text()")
  defp studio(doc), do: xpath(doc, ~x"#{attr_path()}/Studio/text()")
  defp size_of_item(doc), do: xpath(doc, ~x"#{attr_path()}/Size/text()")
  defp total_new(doc), do: xpath(doc, ~x"#{item_path()}/OfferSummary/TotalNew/text()")
  defp total_used(doc), do: xpath(doc, ~x"#{item_path()}/OfferSummary/TotalUsed/text()")
  defp total_collectible(doc), do: xpath(doc, ~x"#{item_path()}/OfferSummary/TotalCollectible/text()")
  defp total_refurbished(doc), do: xpath(doc, ~x"#{item_path()}/OfferSummary/TotalRefurbished/text()")
  defp package_quantity(doc), do: xpath(doc, ~x"#{attr_path()}/PackageQuantity/text()")
  defp part_number(doc), do: xpath(doc, ~x"#{attr_path()}/PartNumber/text()")
  defp asin(doc), do: xpath(doc, ~x"#{item_path()}/ASIN/text()")
  defp parent_asin(doc), do: xpath(doc, ~x"#{item_path()}/ParentASIN/text()")
  defp detail_page_url(doc), do: xpath(doc, ~x"#{item_path()}/DetailPageURL/text()")
  defp sales_rank(doc), do: xpath(doc, ~x"#{item_path()}/SalesRank/text()")

  defp attr_path, do: "#{item_path()}/ItemAttributes"
  defp item_path, do: "/ItemLookupResponse/Items/Item"
end
