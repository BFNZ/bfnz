FactoryBot.define do
  factory :inventory do
    entry_type { "MyString" }
    date { "2023-12-27" }
    book_id { "MyString" }
    quantity { 1 }
    unit_cost { "9.99" }
    person_name { "MyString" }
  end
end
