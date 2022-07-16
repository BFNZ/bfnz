var searchDuplicates;

$(document).ready(function() {
  $('#order-form').on('click', '#discard-order', function(event) {
    event.preventDefault();
    return $('#order-form').html("");
  });
  $('.merged-customers').on('click', '#find-customer-to-merge', function(event) {
    event.preventDefault();
    $('#find-customer-to-merge').hide();
    return $('#find-customer-form').show();
  });
  $('.merged-customers').on('click', '#cancel-merge', function(event) {
    event.preventDefault();
    return $('#merge-preview').html("");
  });
  $('#new_admin_new_customer_form').on('change', '#admin_new_customer_form_first_name', function() {
    return searchDuplicates();
  });
  $('#new_admin_new_customer_form').on('change', '#admin_new_customer_form_last_name', function() {
    return searchDuplicates();
  });
  return $('#new_admin_new_customer_form').on('change', '#admin_new_customer_form_pxid', function() {
    return searchDuplicates();
  });
});

searchDuplicates = function() {
  $(".duplicates-by-name-or-address").html("loading...");
  return $.post('/admin/customers/find_duplicate_by_name_or_address', {
    first_name: $("#admin_new_customer_form_first_name").val(),
    last_name: $("#admin_new_customer_form_last_name").val(),
    pxid: $("#admin_new_customer_form_pxid").val()
  });
};
