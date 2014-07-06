clear_hidden_values = ->
  $("#order_suburb").val('')
  $("#order_city_town").val('')
  $("#order_post_code").val('')
  $("#order_pxid").val('')
  $("#order_ta").val('')

$(document).ready ->
  $(".addressfinder_widget").each ->
    widget = new AddressFinder.Widget(this, "TWVJBCDGM7Y4NPH9QX68", show_locations: false)

    widget.on "result:select", (value, item)->
      $("#order_suburb").val(item.suburb || '')
      $("#order_city_town").val(item.city || '')
      $("#order_post_code").val(item.postcode || '')
      $("#order_pxid").val(item.pxid || '')
      $("#order_ta").val(item.ta.toLowerCase()) if item.ta?

    $(this).on "change", ->
      clear_hidden_values()

  $("#order_tertiary_student").on 'change', ->
    $("#tertiary_institution").toggle()