defmodule Emerald.Parsers.ItemLookup do
  import SweetXml

  def parse(doc) do
    %{
      title: title(doc),
      product_group: product_group(doc),
      manufacturer: manufacturer(doc),
      brand: brand(doc),
      features: features(doc),
      product_type_name: product_type_name(doc),
      binding_name: binding_name(doc),
      adult_product: adult_product(doc),
      model: model(doc),
      ean: ean(doc),
      upc: upc(doc),
      studio: studio(doc),
      size_of_item: size_of_item(doc),
      total_new: total_new(doc),
      total_used: total_used(doc),
      total_collectible: total_collectible(doc),
      total_refurbished: total_refurbished(doc),
      package_quantity: package_quantity(doc),
      part_number: part_number(doc),
      asin: asin(doc),
      parent_asin: parent_asin(doc),
      detail_page_url: detail_page_url(doc),
      sales_rank: sales_rank(doc),
      main_image: main_image(doc),
      variant_images: variant_images(doc)
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
    |> Enum.map fn (node) ->
      %{
        swatch: node |> xpath(~x"./SwatchImage/URL/text()"),
        small: node |> xpath(~x"./SmallImage/URL/text()"),
        thumbnail: node |> xpath(~x"./ThumbnailImage/URL/text()"),
        tiny: node |> xpath(~x"./TinyImage/URL/text()"),
        medium: node |> xpath(~x"./MediumImage/URL/text()"),
        large: node |> xpath(~x"./LargeImage/URL/text()"),
      }
    end
  end

  # defp add_to_wishlist_url

  # defp

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
