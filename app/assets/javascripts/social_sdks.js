//= require social_sdks/tweet
//= require social_sdks/facebook
//= require social_sdks/pinterest

document.addEventListener("turbolinks:load", function() {
  console.log('Turbolinks loaded');
  loadTwitterSDK();
  if (!twttr_events_bound) {
    bindTwitterEventHandlers();
  }

  loadFacebookSDK();
  if (!window.fbEventsBound) {
    bindFacebookEvents();
  }

  if ($('#pin-it').length != 0){
    Pinterest.load();
  }
})
