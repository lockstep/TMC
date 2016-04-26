//= require social_sdks/tweet
//= require social_sdks/facebook
//= require social_sdks/pinterest

var TMC = window.TMC = window.TMC || {};

TMC.components = {};

TMC.define_component = function(name, fn) {
  var obj = {};
  obj.name = name;
  obj.setup = fn;
  TMC.components[name] = obj;
};

TMC.define_component('social buttons', function() {
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
});

TMC.define_component('product index page', function() {
  $('#sidebar .category .name').click(function() {
    $(this).closest('.category').toggleClass('active');
    $(this).closest('.category').find('.subcategories').slideToggle('slow');
  });
});

TMC.setup = function() {
  for (var c in TMC.components) {
    var component = TMC.components[c];
    component.setup();
  }
};

document.addEventListener("turbolinks:load", function() {
  TMC.setup();
});

