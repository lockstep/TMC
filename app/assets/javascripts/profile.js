document.addEventListener("turbolinks:load", function() {
  handleAvatarUpload();
  handleCustomInterest();
  handleCustomCertification();

  function handleAvatarUpload() {
    var $avatar = $('#avatar');
    var avatar = {
      $fileField: $avatar.find("input[type='file']"),
      $newImageName: $avatar.find('.newImageName')
    }

    // update new avatar image name
    avatar.$fileField.change(function(){
      if (!this.files || this.files.length < 1) return;
      avatar.$newImageName.html('Uploading...');
      avatar.$newImageName.addClass('alert alert-info');
      var $form = avatar.$fileField.closest('form');
      $form.find(':input[type="submit"]').click();
      $('input, select, textarea').prop('disabled', true);
    });

    // upload avatar
    $('#avatar a').click(function(e){
      e.preventDefault();
      avatar.$fileField.click();
    });
  }

  function handleCustomInterest() {
    var $interestSection = $('#profile section.interest');
    var interest = {
      $interests: $interestSection.find('.interests'),
      $customInput: $interestSection.find('.custom input'),
      $customAddButton: $interestSection.find('.custom a')
    }

    handleReturnPress(interest);

    // append a new custom interest
    interest.$customAddButton.click(function(e) {
      e.preventDefault();
      var newInterestName = interest.$customInput.val();
      if (isEmpty(newInterestName)) {
        return clearCustomInput(interest.$customInput);
      }
      if (include(newInterestName, allContainerTexts(interest.$interests))) {
        return clearCustomInput(interest.$customInput);
      }
      interest.$interests.append(checkboxElement('interests', newInterestName));
      clearCustomInput(interest.$customInput);
    });
  }

  function handleCustomCertification() {
    var $certificationSection = $('#profile section.certification');
    var certification = {
      $certifications: $certificationSection.find('.certifications'),
      $customInput: $certificationSection.find('.custom input'),
      $customAddButton: $certificationSection.find('.custom a')
    }

    handleReturnPress(certification);

    // append a new custom certification
    certification.$customAddButton.click(function(e) {
      e.preventDefault();
      var newCertificationName = certification.$customInput.val();
      if (isEmpty(newCertificationName)) {
        return clearCustomInput(certification.$customInput);
      }
      if (include(newCertificationName,
                  allContainerTexts(certification.$certifications))) {
        return clearCustomInput(certification.$customInput);
      }
      certification.$certifications.append(checkboxElement('certifications',
                                                           newCertificationName));
      clearCustomInput(certification.$customInput);
    });
  }

  function handleReturnPress(customFieldsObject) {
    customFieldsObject.$customInput.keydown(function(e) {
      if (e.which == 13) {
        e.preventDefault();
        e.stopPropagation();
        customFieldsObject.$customAddButton.click();
      }
    });
  }

  function isEmpty(text) {
    if (!text) return true;
    return text.trim().length == 0;
  }

  function include(value, array) {
    if (!array || !value) return false;
    return $.inArray(value.toLowerCase(), array) != -1;
  }

  function checkboxElement(name, value) {
    return [
      '<div class="checkbox"><label>',
      '<input type="checkbox" name="user[' + name + '][]"',
      'value="'+ value +'" checked="checked">',
      '<div class="text">' + value + '</div>',
      '</label></div>'
    ].join('');
  }

  function clearCustomInput($input) {
    $input.val('');
  }

  function allContainerTexts($container) {
    var $containerTexts = $container.find('.text');
    var names = [];
    $containerTexts.each(function(index, text){
      var name = $(text).text().trim().toLowerCase();
      if (name.length == 0) return;
      names.push(name);
    });
    return names;
  }
});
