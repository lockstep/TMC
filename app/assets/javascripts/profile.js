document.addEventListener("turbolinks:load", function() {

  var $avatarFileField = $("#avatar input[type='file']");
  var $avatarNewImageName = $("#avatar .newImageName");
  $avatarFileField.change(function(){
    if (!this.files || this.files.length < 1) return;
    $avatarNewImageName.html('Uploading...');
    var $form = $avatarFileField.closest('form');
    $form.find(':input[type="submit"]').click();
    $(':input[type="submit"]').prop('disabled', true);
  });

  $('#avatar a').click(function(e){
    e.preventDefault();
    $avatarFileField.click();
  });

});
