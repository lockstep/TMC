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
  // var range = $('#price-range').val();
  // var from, to;
  // if (range) {
  //   from = range.split(';')[0];
  //   to = range.split(';')[1];
  // }
  //
  // $("#price-range").ionRangeSlider({
  //   type: "double",
  //   grid: true,
  //   min: 0,
  //   max: 70,
  //   from: from,
  //   to: to,
  //   step: 0.1,
  //   prefix: "$"
  // });

  $('#sort-select').change(function() {
    $("#sort").val($(this).val());
    $('#product-search-form').submit();
  });

  // make sidebar link clicks submit the form
  $('#sidebar #product-categories a').bind('vclick', function(e) {
    e.preventDefault();
    var topicId = $(this).data('topic-id');
    $("#topic_ids").val(topicId);
    $('#product-search-form').submit();
  });

  // open active topic tree node
  var activeTopic = $("#topic_ids").val();
  if (activeTopic) {
    $('a[data-topic-id=' + activeTopic + ']').addClass('active');
    $('div.well:has(.active)').addClass('expanded');
  }
});

TMC.define_component('product show page', function() {
  $('#product .images-container img').bind('vclick', function() {
    var src = $(this).attr('src');
    $('#product #primary-image').fadeTo(300, 0.10, function() {
      $('#product #primary-image').attr('src', src);
    }).fadeTo(300, 1);
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

