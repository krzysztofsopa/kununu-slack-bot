defmodule KununuSlackBot.Slack do
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    {:ok, response} = HTTPoison.get("https://www.kununu.com/at/partner/KlM=/json", [], [ ssl: [{:versions, [:'tlsv1.2']}] ])
    {status, o} = JSON.decode(response.body)
    points = o["all"]["points"]

    IO.inspect points

    send_message("test", message.channel, slack)
    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
