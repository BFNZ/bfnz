# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#


if Rails.env.development?
  TerritorialAuthority.destroy_all
  Item.destroy_all
end

[
 ["001","Far North District", :far_north],
 ["002","Whangarei District", :whangarei],
 ["003","Kaipara District", :kaipara],
 ["011","Thames-Coromandel District", 'thames-coromandel'],
 ["012","Hauraki District", :hauraki],
 ["013","Waikato District", :waikato],
 ["015","Matamata-Piako District", :matamata_piako],
 ["016","Hamilton City", :hamilton],
 ["017","Waipa District", :waipa],
 ["018","Otorohanga District", :otorohanga],
 ["019","South Waikato District", :south_waikato],
 ["020","Waitomo District", :waitomo],
 ["021","Taupo District", :taupo],
 ["022","Western Bay of Plenty District", :western_bop],
 ["023","Tauranga City", :tauranga],
 ["024","Rotorua District", :rotorua],
 ["025","Whakatane District", :whakatane],
 ["026","Kawerau District", :kawerau],
 ["027","Opotiki District", :opotiki],
 ["028","Gisborne District", :gisborne],
 ["029","Wairoa District", :wairoa],
 ["030","Hastings District", :hastings],
 ["031","Napier City", :napier],
 ["032","Central Hawke's Bay District", :hawkes_bay],
 ["033","New Plymouth District", :new_plymouth],
 ["034","Stratford District", :stratford],
 ["035","South Taranaki District", :south_taranaki],
 ["036","Ruapehu District", :ruapehu],
 ["037","Wanganui District", :wanganui],
 ["038","Rangitikei District", :rangitikei],
 ["039","Manawatu District", :manawatu],
 ["040","Palmerston North City", :palmerston_north],
 ["041","Tararua District", :tararua],
 ["042","Horowhenua District", :horowhenua],
 ["043","Kapiti Coast District", :kapiti_coast],
 ["044","Porirua City", :porirua],
 ["045","Upper Hutt City", :upper_hutt],
 ["046","Lower Hutt City", :lower_hutt],
 ["047","Wellington City", :wellington],
 ["048","Masterton District", :masterton],
 ["049","Carterton District", :carterton],
 ["050","South Wairarapa District", :south_wairarapa],
 ["051","Tasman District", :tasman],
 ["052","Nelson City", :nelson],
 ["053","Marlborough District", :marlborough],
 ["054","Kaikoura District", :kaikoura],
 ["055","Buller District", :buller],
 ["056","Grey District", :grey],
 ["057","Westland District", :westland],
 ["058","Hurunui District", :hurunui],
 ["059","Waimakariri District", :waimakariri],
 ["060","Christchurch City", :christchurch_city],
 ["062","Selwyn District", :selwyn],
 ["063","Ashburton District", :ashburton],
 ["064","Timaru District", :timaru],
 ["065","Mackenzie District", :mackenzie],
 ["066","Waimate District", :waimate],
 ["068","Waitaki District", :waitaki],
 ["069","Central Otago District", :central_otago],
 ["070","Queenstown-Lakes District", :queenstown_lakes],
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
 ['R', "The New Testament Recovery Version", nil, "the_new_testament.jpg", "The New Testament Recovery Version is a comprehensive study Bible accurately translated from the original Greek text into modern English. It features extensive notes emphasizing the revelation of the truth, outlines of each book, cross-references, charts and maps, and more."],
 ['A', "The All Inclusive Christ", "Witness Lee", "the_all_inclusive_christ.jpg", "Lee shows that the good land in all its aspects is actually a type of Christ in His all-inclusiveness. In this book, the riches of the good land are explained and applied to our experience of Christ today."],
 ['G', "The Glorious Church", "Watchman Nee", "the_glorious_church.jpg", "What is the the church and what is its purpose? Watchman Nee uses types of the church from throughout the Bible to show us the church's origin, purpose, and destiny."],
 ['B', "Basic Elements of the Christian Life", "Watchman Nee and Witness Lee", "basic_elements.jpg", "This series details the basic yet crucial elements of the life of a Christian, showing how each provides the foundation for a rich and meaningful Christian life."],
['E', "The Economy of God", "Witness Lee", "the_economy_of_god.jpg", "TODO"],
['K', "The Knowledge of Life", "Witness Lee", "the_knowledge_of_life.jpg", "TODO"]
].each do |code, title, author, image_path, description|
   Item.create!(code: code, title: title, author: author, image_path: image_path, description: description) unless Item.find_by_code(code)
 end

if Rails.env.development?
  User.create!(name: 'Shevaun', email: 'shevaun.coker@gmail.com', password: 'password', password_confirmation: 'password', admin: true) unless User.find_by_email('shevaun.coker@gmail.com')
end
