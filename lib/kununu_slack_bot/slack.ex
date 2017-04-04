defmodule KununuSlackBot.Slack do
  use Slack
  require Logger

  def get_user_info(user_id) do
    cond do
      %{"ok" => true, "user" => user} = Slack.Web.Users.info(user_id) ->
        {:ok, user}
    end
  end

  def get_user_name(user_id) do
    cond do
      {:ok, user} = get_user_info(user_id) ->
        {:ok, user["name"]}
    end
  end

  def handle_connect(slack, state) do
    Logger.info "Connected as #{slack.me.name}!"

    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    if message.user == slack.me.id do
      Logger.debug "Got a message from myself? 0o"
    end

    {:ok, username} = get_user_name(message.user)

    Logger.info "Got a message from @#{username}: #{inspect(message.text)}"

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
