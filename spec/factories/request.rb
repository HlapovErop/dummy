FactoryBot.define do
  factory :request do
    number { Faker::Alphanumeric.alphanumeric(number: 10) } # генерация случайного номера
    description { Faker::Lorem.sentence } # генерация случайного описания
    state { :unprocessed } # предполагаем, что у вас есть enum-поле state у модели Request
    association :user, factory: :user # создание связи с пользователем через фабрику :user
  end
end
