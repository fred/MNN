jQuery ->
  if (Modernizr.touch)
    $('.dropdown-menu').on('touchstart.dropdown.data-api', (e) ->
      e.stopPropagation() )