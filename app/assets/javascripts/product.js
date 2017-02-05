document.addEventListener("turbolinks:load", function() {

  // Auto-submit language form upon new selection
  var changeLanguageFormSelector = '.select-language-form';
  $(changeLanguageFormSelector).find('.select-language-submission').hide();
  $(document).on('change', changeLanguageFormSelector + ' select', function(e) {
    $(changeLanguageFormSelector).closest('form').submit();
  });

});
