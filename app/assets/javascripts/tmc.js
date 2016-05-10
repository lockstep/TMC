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
    $(this).closest('.category').find('.content').slideToggle('slow');
  });

  var range = $('#price-range').val();
  var from, to;
  if (range) {
    from = range.split(';')[0];
    to = range.split(';')[1];
  }

  // show if the user set custom values
  if (from != 1 || to != 49) {
    $('#sidebar #refine').click();
  }

  $("#price-range").ionRangeSlider({
    type: "double",
    grid: true,
    min: 0,
    max: 70,
    from: from,
    to: to,
    step: 0.1,
    prefix: "$"
  });

  $('#sort').change(function() {
    $('#product-search-form').submit();
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

