# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#


if Rails.env.development?
  TerritorialAuthority.destroy_all
  Item.destroy_all
end

[
 ["001","Far North District", 'far north'],
 ["002","Whangarei District", :whangarei],
 ["003","Kaipara District", :kaipara],
 ["011","Thames-Coromandel District", 'thames-coromandel'],
 ["012","Hauraki District", :hauraki],
 ["013","Waikato District", :waikato],
 ["015","Matamata-Piako District", 'matamata-piako'],
 ["016","Hamilton City", :hamilton],
 ["017","Waipa District", :waipa],
 ["018","Otorohanga District", :otorohanga],
 ["019","South Waikato District", 'south waikato'],
 ["020","Waitomo District", :waitomo],
 ["021","Taupo District", :taupo],
 ["022","Western Bay of Plenty District", 'western bay of plenty'],
 ["023","Tauranga City", :tauranga],
 ["024","Rotorua District", :rotorua],
 ["025","Whakatane District", :whakatane],
 ["026","Kawerau District", :kawerau],
 ["027","Opotiki District", :opotiki],
 ["028","Gisborne District", :gisborne],
 ["029","Wairoa District", :wairoa],
 ["030","Hastings District", :hastings],
 ["031","Napier City", :napier],
 ["032","Central Hawke's Bay District", "central hawke's bay"],
 ["033","New Plymouth District", 'new plymouth'],
 ["034","Stratford District", :stratford],
 ["035","South Taranaki District", 'south taranaki'],
 ["036","Ruapehu District", :ruapehu],
 ["037","Wanganui District", :wanganui],
 ["038","Rangitikei District", :rangitikei],
 ["039","Manawatu District", :manawatu],
 ["040","Palmerston North City", 'palmerston north'],
 ["041","Tararua District", :tararua],
 ["042","Horowhenua District", :horowhenua],
 ["043","Kapiti Coast District", 'kapiti coast'],
 ["044","Porirua City", :porirua],
 ["045","Upper Hutt City", 'upper hutt'],
 ["046","Lower Hutt City", 'lower hutt'],
 ["047","Wellington City", :wellington],
 ["048","Masterton District", :masterton],
 ["049","Carterton District", :carterton],
 ["050","South Wairarapa District", 'south wairarapa'],
 ["051","Tasman District", :tasman],
 ["052","Nelson City", :nelson],
 ["053","Marlborough District", :marlborough],
 ["054","Kaikoura District", :kaikoura],
 ["055","Buller District", :buller],
 ["056","Grey District", :grey],
 ["057","Westland District", :westland],
 ["058","Hurunui District", :hurunui],
 ["059","Waimakariri District", :waimakariri],
 ["060","Christchurch City", :christchurch],
 ["062","Selwyn District", :selwyn],
 ["063","Ashburton District", :ashburton],
 ["064","Timaru District", :timaru],
 ["065","Mackenzie District", :mackenzie],
 ["066","Waimate District", :waimate],
 ["068","Waitaki District", :waitaki],
 ["069","Central Otago District", 'central otago'],
 ["070","Queenstown-Lakes District", 'queenstown-lakes'],
 ["071","Dunedin City", :dunedin],
 ["072","Clutha District", :clutha],
 ["073","Southland District", :southland],
 ["074","Gore District", :gore],
 ["075","Invercargill City", :invercargill],
 ["076","Auckland", :auckland],
].each do |code, name, addressfinder_name|
  TerritorialAuthority.create!(code: code, name: name, addressfinder_name: addressfinder_name) unless TerritorialAuthority.find_by_code(code)
end

[
 ['R', "New Testament Recovery Version", nil, "the_new_testament.jpg", "The New Testament Recovery Version is a comprehensive study Bible accurately translated from the original Greek text into modern English. It features extensive notes emphasizing the revelation of the truth, outlines of each book, cross-references, charts and maps, and more.", nil],
 ['T', "Essential Truths Set", "Watchman Nee and Witness Lee", "foundational_christian_truths.jpg", "This series details the basic yet crucial elements of the life of a Christian, showing how each provides the foundation for a rich and meaningful Christian life.", nil],
 ['E', "Christian Experience Set", "Witness Lee", "christian_experience.jpg", "Lee shows that the good land in all its aspects is actually a type of Christ in His all-inclusiveness. In this book, the riches of the good land are explained and applied to our experience of Christ today.", nil],
 ['C', "Christ and the Church Set", "Watchman Nee & Witness Lee", "church_set.jpg", "What is the the church and what is its purpose? Watchman Nee uses types of the church from throughout the Bible to show us the church's origin, purpose, and destiny.", nil],
 ['X1', "Old Set 1", "Watchman Nee and Witness Lee", "old_set_1.png", "Basic Elements 1", DateTime.strptime("01/01/2016 00:00", "%d/%m/%Y %H:%M")],
 ['X2', "Old Set 2", "Watchman Nee and Witness Lee", "old_set_2.png", "Basic Elements 2 plus The Economy of God, and The All Inclusive Christ", DateTime.strptime("01/01/2016 00:00", "%d/%m/%Y %H:%M")],
 ['X3', "Old Set 3", "Watchman Nee and Witness Lee", "old_set_3.png", "Basic Elements 3 plus The Glorious Church, and The Knowledge of Life", DateTime.strptime("01/01/2016 00:00", "%d/%m/%Y %H:%M")],
].each do |code, title, author, image_path, description, deactivated_at|
   Item.create!(code: code, title: title, author: author, image_path: image_path, description: description, deactivated_at: deactivated_at) unless Item.find_by_code(code)
 end

 books_data = [
  ['Basic Elements 1', 'BX1', 'temp1', 'WL/WN'],
  ['Basic Elements 2', 'BX2', 'temp2', 'WL/WN'],
  ['Basic Elements 3', 'BX3', 'temp3', 'WL/WN'],
  ['Economy of God', 'EOG', 'temp4', 'WL'],
  ['The Glorious Church', 'TGC', 'temp5', 'WN'],
  ['All Inclusive Christ', 'AIX', 'temp6', 'WL'],
  ['Knowledge of Life', 'KOL', 'temp7', 'WL'],
  ['Normal Christian Life', 'NCL', 'temp8', 'WN'],
  ['New Testament Recovery Version', 'NT', 'temp9', 'LSM']
]

books_data.each do |title, code, isbn, author|
  Book.create!(title: title, code: code, isbn: isbn, author: author) unless Book.find_by_code(code)
end

books_data.each do |title, code, isbn, author|
  book = Book.find_by_code(code)
  unless book.nil?
    Inventory.create!(
      entry_type: 'Stock In',
      date: DateTime.now,
      book_id: book.id,
      quantity: 10,
      unit_cost: 15.99,
      person_name: 'Admin'
    )
  end
end

if Rails.env.development?
  User.create!(name: 'Shevaun', email: 'shevaun.coker@gmail.com', password: 'password', password_confirmation: 'password', admin: true) unless User.find_by_email('shevaun.coker@gmail.com')
  User.create!(name: 'Russell', email: 'russell.healy@gmail.com', password: 'password', password_confirmation: 'password', admin: true) unless User.find_by_email('russell.healy@gmail.com')
  User.create!(name: 'Paul', email: 'paulesalmon@gmail.com', password: 'password', password_confirmation: 'password', admin: true) unless User.find_by_email('paulesalmon@gmail.com')
end
