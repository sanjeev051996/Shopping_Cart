require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.name "sudeep sharma"  #{ Faker::Name.name }
    f.email "sanj@gmail.com"
    f.password "123456"
    f.phone "5642"
    f.country "bdsaiufh"
    f.address "asvhjbg"
    f.state "dshjvbg"
    f.admin false
    f.dob DateTime.now
  end

  factory :invalid_user, parent: :user do |f|
    f.password nil
  end

  factory :admin_user, parent: :user do |f|
    f.admin true
  end

  factory :invalid_name, parent: :user do |f|
    f.name nil
  end

  factory :invalid_email, parent: :user do |f|
    f.email "gsadfgy354@"
  end
end