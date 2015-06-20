$(document).ready ->
  $('#order-form').on 'click', '#discard-order', (event)->
    event.preventDefault()
    $('#order-form').html("")

  $('.merged-customers').on 'click', '#find-customer-to-merge', (event)->
    event.preventDefault()
    $('#find-customer-to-merge').hide()
    $('#find-customer-form').show()