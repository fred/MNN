jQuery ->
  if !(Modernizr.touch)
    $(".easy-tooltip").easyTooltip
      yOffset: -30,
      xOffset: -60