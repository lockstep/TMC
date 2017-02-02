document.addEventListener("turbolinks:load", function() {

  var $avatarFileField = $("#avatar input[type='file']");
  var $avatarNewImageName = $("#avatar .newImageName");
  $avatarFileField.change(function(){
    if (!this.files || this.files.length < 1) return;
    $avatarNewImageName.html(this.files[0].name);
  });

  $('#avatar a').click(function(e){
    e.preventDefault();
    $avatarFileField.click();
  });

});
