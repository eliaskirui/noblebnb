class ReservationsController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def cancel
    @reservation = current_user.reservations.find(params[:id])
    # Make api call to refund the payment
    refund = Stripe::Refund.create({
                                     payment_intent: @reservation.stripe_payment_intent_id,
                                   })
    @reservation.update(status: :cancelling, stripe_refund_id: refund.id )
    redirect_to reservation_path(@reservation)
  end

  def create
    @reservation = current_user.reservations.new(reservation_params)
      # create a stripe checkout session
    if @reservation.save
      listing = @reservation.listing
      checkout_session = Stripe::Checkout::Session.create(
        success_url: reservation_url(@reservation),
        cancel_url: listing_url(listing),
        customer: current_user.stripe_customer_id,
        mode: 'payment',
        line_items: [{
                       price_data: {
                         unit_amount: listing.nightly_price,
                         currency: 'usd',
                         # product: listing.stripe_product_id,
                         product: 'prod_LiDL8AkEtqhej7',
                       },
                       # price: "price_1L0mvAKuRjpvO6WCQZDQoO4b",

                       quantity: 1 # Num of nights
                     },
                     {
                       price_data: {
                         unit_amount: listing.cleaning_fee,
                         currency: "usd",
                         product: 'prod_LiDL8AkEtqhej7'  # Cleaning fee product ID
                       },
                       # price: "price_1L0mvAKuRjpvO6WCQZDQoO4b",
                       quantity: 1
                     }],
        metadata: {
          reservation_id: @reservation.id,
        },
        payment_intent_data: {
          metadata: {
            reservation_id: @reservation.id,
          }
        }
        )
      @reservation.update(session_id: checkout_session.id)
      redirect_to checkout_session.url, allow_other_host: true
    else
      flash[:errors] = @reservation.errors.full_messages
      redirect_to listing_path(params[:reservation][:listing_id])
      end
  end

  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  private

  def reservation_params
    params.require(:reservation).permit(:listing_id)
  end
end
