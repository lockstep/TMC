document.addEventListener("turbolinks:load", function() {
  TMC.pollForCommentImages();

  var $directImageUpload = $('.direct-image-upload');
  var $dropImageInput = $directImageUpload.find('.input textarea');
  var $status = $directImageUpload.find('.status');

  // upload an image file directly to S3
  $directImageUpload.on('drop', function(e) {
    e.preventDefault();
    var dropFiles = e.originalEvent.dataTransfer.files;
    if (dropFiles.length < 1) return;
    setFormInputsDisabled($(this).parents('form'), true);
    var $form = $(this).parents('form');
    $(this).addClass('dropped-image');
    var file = dropFiles[0];
    if (!/image/.test(file.type)) {
      $form
        .addClass('has-danger')
        .find('.form-control-feedback')
        .text('Please upload an image file');
      return;
    }
    axios
      .get('/aws_s3_auth?filename=' + file.name + '&content_type=' + file.type)
      .then(function(response) {
        return response.data.credentials;
      })
      .then(uploadImage(
        file,
        uploadSuccess($form, file),
        uploadFailure($form, file)
      ));
  });

  $dropImageInput.on('dragover', function(e) {
    e.preventDefault();
    $directImageUpload.addClass('uploading');
  });
  $dropImageInput.on('dragleave', function(e) {
    e.preventDefault();
    $directImageUpload.removeClass('uploading');
  });

  function setFormInputsDisabled($form, disabled) {
    $form.find('input').each(function(item, input){
      $(input).prop('disabled', disabled);
    });
  }

  function uploadSuccess($form, file) {
    return function(s3Key) {
      setFormInputsDisabled($form, false);
      $form
        .find('.direct-image-upload input[name*="raw_image_s3_key"]')
        .val(s3Key);
      $form.submit();
    };
  }

  function uploadFailure($form, file) {
    return function() {
      setFormInputsDisabled($form, false);
      $form
        .addClass('has-danger')
        .find('.form-control-feedback')
        .text('Unable to upload dropped image please retry with new image');
    };
  }

  function uploadImage(file, successHandler, failureHandler) {
    return function(credentials) {
      if (!credentials) return;
      var form = new FormData();
      form.append("AWSAccessKeyId", credentials.AWSAccessKeyId);
      form.append("signature", credentials.signature);
      form.append("acl", credentials.acl);
      form.append("policy", credentials.policy);
      form.append("key", credentials.key);
      form.append("Content-Type", file.type);
      form.append("file", file);
      axios
        .post(credentials.endpoint, form)
        .then(function(response) {
          successHandler(credentials.key);
        })
        .catch(function(error) {
          failureHandler();
        });
    }
  }

  function getS3Key(credentialKey, file) {
    return credentialKey.replace('${filename}', file.name)
  }

});

TMC.pollForCommentImages = function(){
  var $missingImageComments = $('.comments .missing-image').closest('.comment');
  if($missingImageComments.length === 0) return;
  var currentPath = window.location.pathname + window.location.search;
  var path;
  // TODO: Add interest comments api endpoint to clean up this shitty shitty
  // code.
  if(currentPath.match('breakout_sessions')) {
    path = '/api/v1' + currentPath + '/comments';
  } else path = currentPath;
  $.ajax(path, {
    dataType: 'JSON',
    success: function(res) {
      setTimeout(TMC.pollForCommentImages, 2000);
      var comments = res.comments || res.interest.comments;
      $.each($missingImageComments, function(_, comment) {
        var $comment = $(comment);
        var id = $comment.prop('id');
        $.each(comments, function(_, commentJson) {
          if(commentJson.image_url_large && "comment-" + commentJson.id === id) {
            var $img = $('<img />').prop('src', commentJson.image_url_large);
            $comment.find('.comment-image').append($img);
            $comment.find('.missing-image').remove();
          }
        });
      });
    }
  });
}
