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
    sign_url(url)
  end

  def url do
    query = [default_params(), item_lookup("TEST")] |> combine_params

    %URI{scheme: @scheme, host: @host, path: @path, query: query}
    # HTTPotion.get("http://webservices.amazon.co.uk/onca/xml",
    #   query: %{
    #     Service: "AWSECommerceService",
    #     AWSAccessKeyId: Application.get_env(:emerald, :AMAZON_ACCESS_KEY_ID),
    #     AssociateTag: Application.get_env(:emerald, :AMAZON_AFFILIATE_ID),
    #     Timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    #   }
    # )
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
    Base.encode64(hmac) #|> String.Chars.to_string
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
      "S1mall",
      "Tracks",
      "Variations",
      "VariationImages",
      "VariationMatrix",
      "VariationOffers",
      "VariationSummary"
    ], ",")
  end
end
