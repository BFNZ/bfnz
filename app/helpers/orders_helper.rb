module OrdersHelper

  def districts_and_places_data
    @data ||= District.includes(:places).inject({}) do |hash, district|
      hash[district.id] = district.places.pluck(:name)
      hash
    end.to_json
  end
end
