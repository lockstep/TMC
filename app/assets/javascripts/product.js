document.addEventListener("turbolinks:load", function() {

  // Auto-submit language form upon new selection
  var changeLanguageFormSelector = '.select-language-form';
  $(changeLanguageFormSelector).find('.select-language-submission').hide();
  $(document).on('change', changeLanguageFormSelector + ' select', function(e) {
    $(':input[type="submit"]').prop('disabled', true);
    $(changeLanguageFormSelector).closest('form').submit();
  });

  // If js enabled, allow user to add product to cart via ajax
  $(document).on('submit', 'form.new_line_item', function(e) {

    // Submit via AJAX
    var $submitBtn = $(this).find('.btn-cart');
    var valuesToSubmit = $(this).serialize();
    $.ajax({
        type: "POST",
        url: $(this).attr('action'),
        data: valuesToSubmit,
        dataType: "JSON",
        beforeSend: function() {
          $submitBtn.val('Adding...');
        },
        success: function() {
          $submitBtn.val('In Cart');
        }
    });

    // Prevent normal submission
    return false;
  });

});
