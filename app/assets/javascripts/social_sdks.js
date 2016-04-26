//= require social_sdks/tweet
//= require social_sdks/facebook
//= require social_sdks/pinterest

$(document).ready(function(){
  loadTwitterSDK().done(function(script, status) {
    if (!twttr_events_bound) {
      bindTwitterEventHandlers();
    }
  });

  loadFacebookSDK();
  if (!window.fbEventsBound) {
    bindFacebookEvents();
  }

  Pinterest.load();
  if (!window.pinterest_events_bound) {
    Pinterest.bindEventHandlers();
  }
})
