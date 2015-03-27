clear_hidden_values = ->
  $(".hidden-address").val('')

$(document).ready ->
  $(".addressfinder_widget").each ->
    widget = new AddressFinder.Widget(this, "TWVJBCDGM7Y4NPH9QX68", show_locations: false)

    widget.on "result:select", (value, item)->
      $(".hidden-address.suburb").val(item.suburb || '')
      $(".hidden-address.city_town").val(item.city || '')
      $(".hidden-address.post_code").val(item.postcode || '')
      $(".hidden-address.pxid").val(item.pxid || '')
      $(".hidden-address.ta").val(item.ta.toLowerCase()) if item.ta?

    $(this).on "change", ->
      clear_hidden_values()


  $("#tertiary_institution").hide() unless $(".tertiary-institution-toggle").attr('checked')

  $(".tertiary-institution-toggle").on 'change', ->
    $("#tertiary_institution").toggle()

  $(".imagepicker").imagepicker(show_label: true)