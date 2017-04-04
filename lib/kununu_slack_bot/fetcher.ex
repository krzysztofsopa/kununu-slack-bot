defmodule KununuSlackBot.Fetcher do
  def info(companyName) do
    apiSearchUrl = "https://api.kununu.com/v1/search/profiles?q="
    profiles =  getProfiles("#{apiSearchUrl}#{companyName}")
    profile = hd(profiles)

    "Profile name: #{profile["name"]}, Review count: #{profile["review_count"]["online"]}, Product: #{profile["product"]}"
  end

  defp getProfiles(url) do
    {:ok, response} = HTTPoison.get(url, [], [ ssl: [{:versions, [:'tlsv1.2']}] ])
    {status, o} = JSON.decode(response.body)

    o["profiles"]
  end
end
