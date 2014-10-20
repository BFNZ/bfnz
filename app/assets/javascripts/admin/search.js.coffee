$(document).ready ->
  $('.datepicker').datepicker(format: 'yyyy-mm-dd')

  $('#csv').on 'click', ->
    $('#format').val('csv')

  $('#search').on 'click', ->
    $('#format').val('html')