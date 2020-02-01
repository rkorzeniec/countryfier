FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "freddie#{n}#{Time.now.to_i}@email.ch" }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
  end
end
