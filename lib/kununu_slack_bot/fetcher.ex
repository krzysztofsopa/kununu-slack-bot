defmodule KununuSlackBot.Fetcher do
  use Application

  def info(companyName) do
    apiSearchUrl = Application.get_env(:fetcher, KununuSlackBot)[:api_search_url]
    profiles =  getProfiles("#{apiSearchUrl}#{companyName}")

    messages = []
    for profile <- profiles do
      response = "Profile name: #{profile["name"]}, Review count: #{profile["review_count"]["online"]}, Product: #{profile["product"]}"
      messages ++ response
    end

    IO.insepect Enum.join(messages, " ")
  end

  defp getProfiles(url) do
    {:ok, response} = HTTPoison.get(url, [], [ ssl: [{:versions, [:'tlsv1.2']}] ])
    {status, o} = JSON.decode(response.body)
    total_count = o["total_count"]

    o["profiles"]
  end
end
