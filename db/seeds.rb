# frozen_string_literal: true

me = User.find_or_create_by!(
  email: 'eliaskips1@gmail.com'
) do |u|
  u.password = '123456'
  u.confirmed_at = DateTime.now
end
10.times do
  listing = Listing.create(
    host: me,
    title: Faker::Lorem.words.join(''),
    about: Faker::Lorem.paragraphs.join("\n"),
    max_guests: (1...15).to_a.sample,
    address_line1: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    country: 'US',
    status: %i[draft published].sample,
    nightly_price: 12000,
    cleaning_fee: 5000,

  )
end


10.times do
  host = User.create!(
    email: Faker::Internet.email,
    password: Faker::Internet.password
  )

  10.times do
    listing = Listing.create(
      host: host,
      title: Faker::Lorem.words.join(''),
      about: Faker::Lorem.paragraphs.join("\n"),
      max_guests: (1...15).to_a.sample,
      address_line1: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      country: 'US',
      status: %i[draft published].sample,
      nightly_price: 12000,
      cleaning_fee: 5000,

    )
  end
end
