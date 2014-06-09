# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

District.destroy_all
{
  'Auckland City'     => ['Auckland City', 'Manukau City', 'North Shore City', 'Papakura', 'Rodney', 'Waitakere City'],
  'Bay of Plenty'     => ['Kawerau', 'Opotiki', 'Rotorua', 'Tauranga', 'Western Bay of Plenty', 'Whakatane'],
  'Canterbury'        => ['Ashburton', 'Banks Peninsula', 'Christchurch City', 'Hurunui', 'Kaikoura', 'Mackenzie', 'Selwyn', 'Timaru', 'Waimakariri', 'Waimate'],
  'Gisborne'          => ['Gisborne'],
  'Hawkes Bay'        => ['Central Hawkes Bay', 'Hastings', 'Napier City', 'Wairoa'],
  'Manawatu-Wanganui' => ['Horowhenua', 'Manawatu', 'National Park', 'Ohura', 'Palmerston North City', 'Rangatikei', 'Tararua', 'Taumarunui', 'Waimarino', 'Waiouru', 'Wanganui'],
  'Marlborough'       => ['Awatere', 'Blenheim', 'Pelorous/Northern Marlborough Sounds', 'Picton', 'Wairau'],
  'Nelson'            => ['Nelson'],
  'Northland'         => ['Far North', 'Kaipara', 'Whangarei'],
  'Otago'             => ['Central Otago', 'Clutha', 'Dunedin City', 'Queenstown Lakes', 'Waitaki'],
  'Southland'         => ['Gore', 'Invercargill City', 'Southland'],
  'Taranaki'          => ['New Plymouth', 'South Taranaki', 'Stratford'],
  'Tasman'            => ['Golden Bay', 'Lakes/Murchison', 'Motueka', 'Moutere/Waimea', 'Richmond'],
  'Waikato'           => ['Franklin', 'Hamilton City', 'Hauraki', 'Matamata-Piako', 'Otorohanga', 'South Waikato', 'Taupo', 'Thames-Coromandel', 'Waikato', 'Waipa', 'Waitomo'],
  'Wairarapa'         => ['Carterton', 'Masterton', 'South Wairarapa'],
  'Wellington'        => ['Hutt City', 'Kapiti Coast', 'Porirua City', 'Upper Hutt City', 'Wellington City'],
  'West Coast'        => ['Buller', 'Grey', 'Westland']
}.each do |district_name, places|
  district = District.create!(name: district_name)
  places.each { |place_name| district.places.create!(name: place_name) }
end
