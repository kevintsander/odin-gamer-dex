FactoryBot.define do
  factory :user_relationship do
    user
    friend factory: :user
  end
end

FactoryBot.define do
  factory :user do
    id { rand(5000) }
    name { Faker::Name.name }
    password { Faker::Internet.password }
    username { Faker::Internet.username }
    age { rand(120) }
    email { Faker::Internet.email }
    bio { Faker::Lorem.paragraph }
  end
end
