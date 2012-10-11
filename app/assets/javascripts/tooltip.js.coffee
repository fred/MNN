jQuery ->
  if !(Modernizr.touch)
    $("a#tooltip").easyTooltip
      yOffset: -30,
      xOffset: -60