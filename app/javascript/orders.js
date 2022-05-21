var clear_hidden_values, fitTextArea;

clear_hidden_values = function() {
  return $(".hidden-address").val('');
};

fitTextArea = function(element) {
  var results, rows;
  if (!$(element).is('textarea')) {
    return;
  }
  if (!((element.clientHeight != null) && (element.scrollHeight != null))) {
    return;
  }
  rows = $(element).attr("rows") || 1;
  results = [];
  while (element.clientHeight < element.scrollHeight && rows <= 10) {
    results.push($(element).attr("rows", ++rows));
  }
  return results;
};

$(document).ready(function() {
  $(".addressfinder_widget").each(function() {
    var widget;
    widget = new AddressFinder.Widget(this, "DYJ8TQLUGPR9VEHNC6KW", {
      show_locations: false
    });
    fitTextArea(this);
    widget.on("result:select", function(value, item) {
      $(this.element).data("selected", value);
      $(".hidden-address.suburb").val(item.suburb || '');
      $(".hidden-address.city_town").val(item.city || '');
      $(".hidden-address.post_code").val(item.postcode || '');
      $(".hidden-address.pxid").val(item.pxid || '');
      $(".hidden-address.pxid").trigger('change');
      $(".hidden-address.ta").val(item.ta);
      $(".hidden-address.dpid").val(item.dpid);
      $(".hidden-address.x").val(item.x);
      $(".hidden-address.y").val(item.y);
      return fitTextArea(this.element);
    });
    return $(this).on("change", function() {
      if (($(this).data("selected") || '').trim() !== $(this).val().trim()) {
        return clear_hidden_values();
      }
    });
  });
  if (!$(".tertiary-institution-toggle").attr('checked')) {
    $("#tertiary_institution").hide();
  }
  $(".tertiary-institution-toggle").on('change', function() {
    return $("#tertiary_institution").toggle();
  });
  return $(".imagepicker").imagepicker({
    show_label: true
  });
});
