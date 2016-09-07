$(function() {

  document.addEventListener("trix-attachment-add", function(event) {
    var attachment;
    attachment = event.attachment;
    if (attachment.file) {
      return uploadAttachment(attachment);
    }
  });

  var uploadAttachment = function(attachment) {
    var file, form, $form, key, url, host, xhr;
    file = attachment.file;

    $form = $('#post-form');
    key = $form.data('key');
    url = $form.data('url');
    host = $form.data('host');

    form = new FormData;
    form.append("AWSAccessKeyId", $form.data('access-key'));
    form.append("signature", $form.data('signature'));
    form.append("acl", $form.data('acl'));
    form.append("policy", $form.data('policy'));
    form.append("success_action_status", $form.data('status'));
    form.append("key", key);
    form.append("Content-Type", file.type);
    form.append("file", file);

    xhr = new XMLHttpRequest;
    xhr.open("POST", url, true);
    xhr.upload.onprogress = function(event) {
      var progress;
      progress = event.loaded / event.total * 100;
      return attachment.setUploadProgress(progress);
    };
    xhr.onload = function() {
      if (xhr.status === 201) {
        return attachment.setAttributes({
          url: $(xhr.responseXML).find("Location").text()
        });
      }
    };
    return xhr.send(form);
  };
});
