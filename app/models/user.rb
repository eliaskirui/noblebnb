# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  provider               :string
#  uid                    :string
#  stripe_customer_id     :string
#  name                   :string
#  is_host                :boolean          default(FALSE)
#  stripe_account_id      :string
#  charges_enabled        :boolean          default(FALSE)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :listings, foreign_key: :host_id
  has_many :reservations, foreign_key: :guest_id
  has_many :host_reservations, class_name: 'Reservation', through: :listings, source: :reservations
  has_many :notifications, as: :recipient

  after_commit :maybe_create_stripe_customer, on: %i[create update]

  def maybe_create_stripe_customer
    return if !stripe_customer_id.blank?

    customer = Stripe::Customer.create(
      email: email,
      name: name,
      metadata: {
        noblebnb_id: id
      }
    )
    update(stripe_customer_id: customer.id)
  end


  def self.from_omniauth(access_token)
    user = User.where(email: access_token.info.email).first
    unless user
      user = User.create(
        email: access_token.info.email,
        password: Devise.friendly_token[0,20]
      )
    end
    user.email = access_token.info.email
    user.skip_confirmation!
    # user.image = access_token.info.image
    # user.uid = access_token.uid
    # user.provider = access_token.provider
    user.save

    user
  end
end
