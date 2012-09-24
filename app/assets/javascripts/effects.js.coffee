jQuery ->
  if !(Modernizr.touch)
    $("a.image-popup").fancybox
      openEffect  : 'none',
      closeEffect  : 'none'
    $("a#tooltip").easyTooltip
      yOffset: -30,
      xOffset: -60
    $('a#popover').popover
      placement: 'bottom'