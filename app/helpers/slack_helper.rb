module SlackHelper
  def post_to_slack(message, channel)
    # we would need to integrate slack api, this is faking a message to slack
    p "#{message} to: #{channel}"
  end
end
