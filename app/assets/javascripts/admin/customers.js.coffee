
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

  $('#search-duplicates').click (event)->
    event.preventDefault()
    searchDuplicates()

  $('#new_admin_new_customer_form').on 'change', '#admin_new_customer_form_first_name', ->
    searchDuplicates()
  $('#new_admin_new_customer_form').on 'change', '#admin_new_customer_form_last_name', ->
    searchDuplicates()
  $('#new_admin_new_customer_form').on 'change', '#admin_new_customer_form_pxid', ->
    searchDuplicates()

searchDuplicates = ->
  $.post '/admin/customers/find_duplicate_by_name_or_address', {
    first_name: $("#admin_new_customer_form_first_name").val()
    last_name:  $("#admin_new_customer_form_last_name").val()
    pxid:       $("#admin_new_customer_form_pxid").val()
  }
