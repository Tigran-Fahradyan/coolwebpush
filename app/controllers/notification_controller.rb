class NotificationController < ApplicationController
  def index

  end

  def get_vapid_keys
    # save the keys in env file
    require 'webpush'
    vapid_key = Webpush.generate_key
    hash = {
        public_key: vapid_key.public_key,
        private_key: vapid_key.private_key
    }
    abort hash.inspect
  end

  def sendPush
    # destroy all users that has the same auth token
    User.where(auth_key: params[:subscription][:keys][:auth]).destroy_all

    # create notification data
    notif_data = NotificationData.create(
        endpoint: params[:subscription][:endpoint],
        p256dh_key: params[:subscription][:keys][:p256dh],
        auth_key: params[:subscription][:keys][:auth]
    )

    # create user assignet to notification data
    user = User.create(
        auth_key: params[:subscription][:keys][:auth],
        :notif_id => notif_data.id
    )

    sendPayload(user, notif_data)
    render body: nil
  end

  def sendPayload(user, notif_data)
    if user.notif_id.present?
      Webpush.payload_send(
          endpoint: notif_data.endpoint,
          message: get_message,
          p256dh: notif_data.p256dh_key,
          auth: notif_data.auth_key,
          ttl: 24 * 60 * 60,
          vapid: {
              subject: ENV['VAOID_SUBJECT'],
              public_key: ENV['VAPID_PUBLIC_KEY'],
              private_key: ENV['VAPID_PRIVATE_KEY']
          }
      )
      puts "success"
    else
      puts "failed"
    end
  end

  def get_message()
    "Hello World"
  end

  def provide_vapid_key
    status = ENV['VAPID_PUBLIC_KEY'].length > 0 ? true : false
    data = Base64.urlsafe_decode64(ENV['VAPID_PUBLIC_KEY']).bytes
    return render json: {status: status, data: data}
  end

end
