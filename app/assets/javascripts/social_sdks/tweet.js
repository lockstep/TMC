var bindTwitterEventHandlers,
    loadTwitterSDK,
    renderTweetButtons,
    twttr_events_bound;

twttr_events_bound = false;

bindTwitterEventHandlers = function() {
  $(document).on('turbolinks:load', renderTweetButtons);
  return twttr_events_bound = true;
};

renderTweetButtons = function() {
  $('.twitter-share-button').each(function() {
    var button;
    button = $(this);
    if (button.data('url') == null) {
      button.attr('data-url', document.location.href);
    }
    if (button.data('text') == null) {
      return button.attr('data-text', document.title);
    }
  });
  return twttr.widgets.load();
};

loadTwitterSDK = function() {
  return $.getScript("//platform.twitter.com/widgets.js");
};
