class Api::V1::MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def show
    @message = Message.find(params[:id])
    @answers = @message.message_buttons.map do |b|
      {
        text: b.text,
        count: b.message_answers.size,
        percentage: (b.message_answers.size.to_f / @message.message_answers.size) * 100
      }
    end
  end

  REMIND_HOUR = 14.freeze
  REMIND_MINUTE = 0.freeze
  def create
    message_params = params.permit(:message, :require_confirm, :due_at)
    message_buttons_params = params.permit(message_buttons: [:text])
    mentions_params = params.permit(mentions: [:slack_id, :name, :profile_picture_url])

    message = Message.new(message_params).tap do |ms|
      ms.user_id = 1 # TODO: Pass the user id parameter from session
      ms.callback_id = Slack::MessageButton.create_identifier
      ms.message_buttons = message_buttons_params[:message_buttons].map do |m|
        MessageButton.new(m).tap do |button|
          button.name = Slack::MessageButton.create_identifier
        end
      end
      ms.mentions = mentions_params[:mentions].map {|m| Mention.new(m) }
    end

    Message.transaction do
      begin
        message.save!
      rescue => e
        Rails.logger.error e.inspect
      end
    end

    message.mentions.each do |m|
      SlackMessageWorker.perform_async m.id
      remind_day = message.due_at - 1.day
      wait = Time.new(remind_day.year, remind_day.month, remind_day.day, REMIND_HOUR, REMIND_MINUTE) - Time.now
      RemindWorker.perform_at(wait, m.id)
    end

    head :created
  end
end
