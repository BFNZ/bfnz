$(document).ready ->
  $('#district').on 'change', ->
    selected_district = $(this).val()
    places = $(this).data('places')[selected_district]
    place_options = ''

    for place in places
      place_options += "<option>#{place}</option>"

    $('#order_place').removeAttr("disabled").empty().append(place_options)