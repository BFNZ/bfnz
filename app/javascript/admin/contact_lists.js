$(document).ready(function() {
  return $('.download-csv-form').submit(function() {
    return $(this).find('input[type=submit]').prop('disabled', true);
  });
});
