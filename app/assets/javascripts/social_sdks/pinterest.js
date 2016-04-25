var Pinterest;

Pinterest = {
  load: function() {
    delete window["PIN_" + ~~((new Date).getTime() / 864e5)];
    $('head').append("<script async defer data-pin-hover='true' src='//assets.pinterest.com/js/pinit.js'></script>");
  }
};
