//= require social_sdks/tweet
//= require social_sdks/facebook
//= require social_sdks/pinterest

$(document).ready(function(){
  console.log('Turbolinks loaded');
  loadTwitterSDK().done(function(script, status) {
    if (!twttr_events_bound) {
      bindTwitterEventHandlers();
    }
  });

  loadFacebookSDK();
  if (!window.fbEventsBound) {
    bindFacebookEvents();
  }

  if ($('#pin-it').length != 0){
    Pinterest.load();
  }
})
