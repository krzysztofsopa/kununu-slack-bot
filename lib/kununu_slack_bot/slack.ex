defmodule KununuSlackBot.Slack do
  use Slack
  require Logger

  def handle_connect(slack, state) do
    Logger.info "Connected as #{slack.me.name}!"
    
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    Logger.info "Got a message: #{inspect(message)}"

    {:ok, response} = HTTPoison.get("https://www.kununu.com/at/partner/KlM=/json", [], [ ssl: [{:versions, [:'tlsv1.2']}] ])
    {status, o} = JSON.decode(response.body)
    points = o["all"]["points"]
    
    Logger.info "Sending info about KlM= #{inspect(points)}"

    send_message("Kununu score: #{points}", message.channel, slack)

    {:ok, state}
  end
  def handle_event(_, _, state) do
    {:ok, state}
  end

  def handle_info({:message, text, channel}, slack, state) do
    Logger.info "Sending your message to #{channel}!"

    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state) do
    {:ok, state}
  end
end
