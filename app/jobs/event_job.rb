class EventJob < ApplicationJob
  queue_as :default

  def perform(event)
    case event.source
    when 'stripe'
      stripe_event = Stripe::Event.construct_from(
        JSON.parse(event.request_body, symbolize_names: true)
      )
      begin
        handle_stripe(stripe_event)
        event.update(
          event_type: stripe_event.type,
          error_message: '',
          status: :processed
        )
      rescue StandardError => e
        event.update(
          error_message: e.message,
          status: :failed
        )
      end
      handle_stripe(event)
    else
      event.update(error_messages: "Unknown source #{event.source}",
                   status: :failed
                   )
    end
  end

  def handle_stripe(event)
    case event.type
    when 'account.updated'
      account = event.data.object
      user = User.find_by(stripe_account_id: account.id)
      user.update(charges_enabled: account.charges_enabled)
    when 'checkout.session.completed'
      # do something with the checkout session and the reservation here.
      checkout_session = event.data.object

      # puts "Checkout Session ID: #{ checkout_session.id }"
      # puts "Checkout Session Metadata: #{ checkout_session.metadata }"
      reservation = Reservation.find_by(session_id: checkout_session.id)
      if reservation.nil?
        raise "No reservation found with Checkout Session ID #{checkout_session.id}"
      end
      reservation.update(status: :booked, stripe_payment_intent_id: checkout_session.payment_intent)
      HostReservationBookedNotification.with(reservation: reservation, message: "New Booking #{reservation.guest.email} is coming on #{reservation.start_date}").deliver_later(reservation.host)
      GuestReservationBookedNotification.with(reservation: reservation).deliver_later(reservation.guest)

    when 'checkout.session.expired'
      checkout_session = event.data.object_id
      reservation = Reservation.find_by(session_id: checkout_session.id)
      if reservation.nil?
        raise 'No reservation with Checkout Session ID #{checkout_session.id}'
      end

      reservation.update(status: :expired)

    when 'charge.refunded'
      charge = event.data.object
      reservation = Reservation.find_by(stripe_payment_intent_id: charge.payment_intent)

      if reservation.nil?
        raise "No reservation found with Payment Intent ID #{charge.payment_intent}"
      end
      reservation.update(status: :cancelled)
    when 'identity.verification_session.verified'
      session = event.data.object
      user = User.find_by(id: session.metadata.user_id)
      if user.nil?
        raise "No user found with ID #{session.metadata.user_id}"
      end
      if session.status == 'verified'
        user.update(identity_verified: true)
      else
        user.update(identity_verified: false)
      end
    end
  end
end
