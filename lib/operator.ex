defmodule Emerald.Operator do
  @scheme "http"
  @path "/onca/xml"

  def item_lookup(asin, config) do
    query = [%{
      Operation: "ItemLookup",
      ItemId: asin,
      IdType: "ASIN",
      ResponseGroup: default_response_groups()
    }, default_params(config.access_key, config.affiliate_id)] |> combine_params

    url = %URI{scheme: @scheme, host: config.host, path: @path, query: query}
    query = [%{ Signature: sign_url(url, config.secret_key) }, query] |> combine_params

    doc = HTTPotion.get("#{@scheme}://#{config.host}#{@path}?#{URI.encode_query(query)}").body

    Emerald.Parsers.ItemLookup.run(doc)
  end

  defp default_params(access_key, affiliate_id) do
    %{
      "Service": "AWSECommerceService",
      "AWSAccessKeyId": access_key,
      "AssociateTag": affiliate_id,
      "Timestamp": DateTime.utc_now() |> DateTime.to_iso8601()
    }
  end

  defp sign_url(url_parts, secret_key) do
    hmac = :crypto.hmac(
        :sha256,
        secret_key,
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
