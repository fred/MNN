$(document).ready(function() {
  
  if (!(Modernizr.touch) && !(jQuery.browser.msie)) {
    
    // Font Resizer
    var min=9;
    var normal=14;
    var max=20;
    
    $("#resetFont").click(function() {
      $('#item_body p').each(function() {
        $(this).css("font-size", normal+"px");
      });
    });

    $("#increaseFont").click(function() {
      $('#item_body p').each(function() {
        p = this;
        s = parseInt($(p).css("font-size").replace("px",""));
        s += 1;
        $(p).css("font-size", s+"px");
      });
    });

    $("#decreaseFont").click(function() {
      $('#item_body p').each(function() {
        p = this;
        s = parseInt($(p).css("font-size").replace("px",""));
        s -= 1;
        $(p).css("font-size", s+"px");
      });
    });

    // Show the font-resizer for non-touch devices
    $("#font_control").show();
  }
});
