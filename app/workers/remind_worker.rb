class RemindWorker
  include Sidekiq::Worker
  sidekiq_options queue: :remind, retry: 5
  def perform(mention_id)
    message_button = Slack::MessageButton.new

    mention = Mention.find(mention_id)
    message = mention.message

    begin
      message_button.chat_update(
        {
          channel: mention.channel,
          ts: mention.ts,
          text: "[remind] #{message.message}"
        }
      )
    rescue => e
      Rails.logger.error e.inspect
    end
  end
end