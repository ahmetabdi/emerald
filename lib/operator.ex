defmodule Emerald.Operator do
  @moduledoc """
  Documentation for Emerald.
  """

  @scheme "http"
  @host System.get_env("AMAZON_HOST")
  @path "/onca/xml"

  def item_lookup(asin) do
    query = [%{
      Operation: "ItemLookup",
      ItemId: asin,
      IdType: "ASIN",
      ResponseGroup: default_response_groups()
    }, default_params()] |> combine_params

    url = %URI{scheme: @scheme, host: @host, path: @path, query: query}
    query = [%{ Signature: sign_url(url) }, query] |> combine_params

    HTTPotion.get(@scheme <> "://" <> @host <> @path <> "?" <> URI.encode_query(query))
  end

  defp default_params do
    %{
      "Service": "AWSECommerceService",
      "AWSAccessKeyId": System.get_env("AMAZON_ACCESS_KEY_ID"),
      "AssociateTag": System.get_env("AMAZON_AFFILIATE_ID"),
      "Timestamp": DateTime.utc_now() |> DateTime.to_iso8601()
    }
  end

  defp sign_url(url_parts) do
    hmac = :crypto.hmac(
        :sha256,
        System.get_env("AMAZON_SECRET_KEY"),
        Enum.join(["GET", url_parts.host, url_parts.path, URI.encode_query(url_parts.query)], "\n")
      )
    Base.encode64(hmac)
  end

  defp combine_params(params_list) do
    List.foldl params_list, Map.new, fn(params, all_params) ->
      Map.merge params, all_params
    end
  end

  defp default_response_groups do
    Enum.join([
      "Accessories",
      "AlternateVersions",
      "BrowseNodes",
      "EditorialReview",
      "Images",
      "ItemAttributes",
      "ItemIds",
      "Large",
      "Medium",
      "OfferFull",
      "OfferListings",
      "Offers",
      "OfferSummary",
      "PromotionSummary",
      "Reviews",
      "SalesRank",
      "Similarities",
      "Small",
      "Tracks",
      "Variations",
      "VariationImages",
      "VariationMatrix",
      "VariationOffers",
      "VariationSummary"
    ], ",")
  end
end
