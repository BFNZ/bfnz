$(document).ready ->
  $('#order-form').on 'click', '#discard-order', (event)->
    event.preventDefault()
    $('#order-form').html("")