var Pinterest;
var pinterest_events_bound = false;

Pinterest = {
  load: function() {
    // only load on product pages
    if ($('section#product').length != 0){
      delete window["PIN_" + ~~((new Date).getTime() / 864e5)];
      $('head').append("<script type='text/javascript' async defer src='//assets.pinterest.com/js/pinit.js'></script>");
    }
  },
  bindEventHandlers: function() {
    $(document).on('turbolinks:load', Pinterest.load);
    return pinterest_events_bound = true;
  }
};
