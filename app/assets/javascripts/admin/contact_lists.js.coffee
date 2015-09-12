$(document).ready ->
  $('.download-csv-form').submit ->
    $(this).find('input[type=submit]').prop('disabled', true)