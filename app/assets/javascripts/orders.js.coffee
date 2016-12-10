clear_hidden_values = ->
  $(".hidden-address").val('')

fitTextArea = (element) ->
  return unless $(element).is('textarea')
  return unless element.clientHeight? && element.scrollHeight?

  rows = $(element).attr("rows") || 1
  while element.clientHeight < element.scrollHeight && rows <= 10
    $(element).attr("rows", ++rows)

$(document).ready ->
  $(".addressfinder_widget").each ->
    widget = new AddressFinder.Widget(this, "TWVJBCDGM7Y4NPH9QX68", show_locations: false)
    fitTextArea(@)

    widget.on "result:select", (value, item)->
      $(".hidden-address.suburb").val(item.suburb || '')
      $(".hidden-address.city_town").val(item.city || '')
      $(".hidden-address.post_code").val(item.postcode || '')
      $(".hidden-address.pxid").val(item.pxid || '')
      $(".hidden-address.ta").val(item.ta)
      $(".hidden-address.dpid").val(item.dpid)
      $(".hidden-address.x").val(item.x)
      $(".hidden-address.y").val(item.y)
      fitTextArea(@.element)

    $(this).on "change", ->
      clear_hidden_values()


  $("#tertiary_institution").hide() unless $(".tertiary-institution-toggle").attr('checked')

  $(".tertiary-institution-toggle").on 'change', ->
    $("#tertiary_institution").toggle()

  $(".imagepicker").imagepicker(show_label: true)
