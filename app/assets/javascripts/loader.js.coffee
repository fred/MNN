$(window).bind 'page:fetch', ->
  $('body').append("<div class='modal'></div>")
  $('body').addClass("loading")

# It's not needed to remove the class since the body will be overwritten