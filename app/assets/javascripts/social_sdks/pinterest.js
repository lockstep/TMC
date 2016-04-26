var Pinterest;
var pinterest_events_bound;

pinterest_events_bound = false;

Pinterest = {
  load: function() {
    if ($('#pin-it').length != 0){
      delete window["PIN_" + ~~((new Date).getTime() / 864e5)];
      $.getScript("//assets.pinterest.com/js/pinit.js");
      $('head').append("<script async defer data-pin-hover='true' src='//assets.pinterest.com/js/pinit.js'></script>");
    }
  },
  bindEventHandlers: function() {
    $(document).on('turbolinks:load', Pinterest.load);
    return pinterest_events_bound = true;
  }
};
