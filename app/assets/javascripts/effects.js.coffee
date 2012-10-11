jQuery ->
  if !(Modernizr.touch)
    $("a.image-popup").fancybox
      openEffect  : 'none',
      closeEffect  : 'none'
    $('a#popover').popover
      placement: 'bottom'