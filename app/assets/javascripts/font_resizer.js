$(document).ready(function() {
  
  if (!(Modernizr.touch)) {
    
    // Font Resizer
    var min=9;
    var normal=14;
    var max=20;
    $("#resetFont").click(function() {
       var p = document.getElementsByTagName('p');
       for(i=0;i<p.length;i++) {
          p[i].style.fontSize = normal+"px";
       }
    });
    $("#increaseFont").click(function() {
       var p = document.getElementsByTagName('p');
       for(i=0;i<p.length;i++) {
          if(p[i].style.fontSize) {
             var s = parseInt(p[i].style.fontSize.replace("px",""));
          } else {
             var s = normal;
          }
          if(s!=max) {
             s += 1;
          }
          p[i].style.fontSize = s+"px";
       }
    });
    $("#decreaseFont").click(function() {
       var p = document.getElementsByTagName('p');
       for(i=0;i<p.length;i++) {
          if(p[i].style.fontSize) {
             var s = parseInt(p[i].style.fontSize.replace("px",""));
          } else {
             var s = normal;
          }
          if(s!=min) {
             s -= 1;
          }
          p[i].style.fontSize = s+"px";
       }
    });
    // Show the font-resizer for non-touch devices
    $("#font_control").show();
  }
});
