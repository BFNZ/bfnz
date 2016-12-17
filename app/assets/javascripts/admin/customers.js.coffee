$(document).ready ->
  $('#order-form').on 'click', '#discard-order', (event)->
    event.preventDefault()
    $('#order-form').html("")

  $('.merged-customers').on 'click', '#find-customer-to-merge', (event)->
    event.preventDefault()
    $('#find-customer-to-merge').hide()
    $('#find-customer-form').show()

  $('.merged-customers').on 'click', '#cancel-merge', (event)->
    event.preventDefault()
    $('#merge-preview').html("")

# Causing issues with data entry
  #$('#new_admin_new_customer_form').on 'change', '#admin_new_customer_form_last_name', (event)->
  #  event.preventDefault()
  #  $('#search-duplicates').click()
