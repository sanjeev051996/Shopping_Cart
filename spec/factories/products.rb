FactoryGirl.define do
  factory :product do |f|
    f.name "red mi note 3"  #{ Faker::Name.name }
    f.description "excellent design, cover, hardware parths, os"
    f.price 10000.00
    f.avatar_content_type "image.jpg"
    f.tax_rate 12.26
    f.stock 15
    f.cod 0
    f.shipping_charge_rate 8.12
  end
end
