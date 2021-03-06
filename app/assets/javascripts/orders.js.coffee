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
    widget = new AddressFinder.Widget(this, "DYJ8TQLUGPR9VEHNC6KW", show_locations: false)
    fitTextArea(@)

    widget.on "result:select", (value, item)->
      $(@.element).data("selected", value)
      $(".hidden-address.suburb").val(item.suburb || '')
      $(".hidden-address.city_town").val(item.city || '')
      $(".hidden-address.post_code").val(item.postcode || '')
      $(".hidden-address.pxid").val(item.pxid || '')
      $(".hidden-address.pxid").trigger('change')
      $(".hidden-address.ta").val(item.ta)
      $(".hidden-address.dpid").val(item.dpid)
      $(".hidden-address.x").val(item.x)
      $(".hidden-address.y").val(item.y)
      fitTextArea(@.element)

    $(this).on "change", ->
      if ($(this).data("selected") || '').trim() != $(this).val().trim()
        clear_hidden_values()

  $("#tertiary_institution").hide() unless $(".tertiary-institution-toggle").attr('checked')

  $(".tertiary-institution-toggle").on 'change', ->
    $("#tertiary_institution").toggle()

  $(".imagepicker").imagepicker(show_label: true)
