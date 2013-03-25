jQuery ->
  if !(Modernizr.touch) && !(jQuery.browser.msie)
    min = 9
    normal = 15
    max = 22
    lineHeight = 20
    $("#resetFont").click ->
      $('#item_body p').each ->
        $(this).css("font-size", normal+"px")
        $(this).css("line-height", lineHeight+"px")
    $("#increaseFont").click ->
      $('#item_body p').each ->
        p = this
        s = parseInt($(p).css("font-size").replace("px",""))
        h = (s-2)*2
        s += 1
        $(p).css("font-size", s+"px")
        $(p).css("line-height", h+"px")
    $("#decreaseFont").click ->
      $('#item_body p').each ->
        p = this
        s = parseInt($(p).css("font-size").replace("px",""))
        h = (s-3)*2
        s -= 1
        $(p).css("font-size", s+"px")
        $(p).css("line-height", h+"px")
    $("#font_control").show();