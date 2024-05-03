FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    password { Faker::Internet.password }
    role { :user } # предполагаем, что у вас есть enum-поле role у модели User
  end

  trait :admin do
    role { :admin }
  end
end
