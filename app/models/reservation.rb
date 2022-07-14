# == Schema Information
#
# Table name: reservations
#
#  id                       :bigint           not null, primary key
#  listing_id               :bigint           not null
#  session_id               :string
#  guest_id                 :bigint           not null
#  status                   :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  stripe_payment_intent_id :string
#  stripe_refund_id         :string
#
class Reservation < ApplicationRecord
  belongs_to :listing
  belongs_to :guest, class_name: 'User'
  enum status: {pending: 0, booked: 1, cancelling: 3, cancelled: 2}
  has_one :calendar_event, dependent: :destroy, required: true

  delegate :start_date, to: :calendar_event
  delegate :end_date, to: :calendar_event
  delegate :nights, to: :calendar_event
end
