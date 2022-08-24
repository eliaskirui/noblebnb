# To deliver this notification:
#
# HostReservationBookedNotification.with(post: @post).deliver_later(current_user)
# HostReservationBookedNotification.with(post: @post).deliver(current_user)

class HostReservationBookedNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: 'ReservationMailer', method: :host_booked
  deliver_by :twilio
  # deliver_by :twilio, format: :format_for_twilio
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :reservation
  param :message

  # Define helper methods to make rendering easier.
  #
  # def message
  #   t(".message")
  # end
  #
  # def url
  #   post_path(params[:post])
  # end
end
