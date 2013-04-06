$(window).bind 'page:fetch', ->
  $('body').append("<div class='modal'></div>")
  $('body').addClass("loading")

# $(window).bind 'page:receive', ->
#   $('.modal').remove()
#   $('body').removeClass("loading")

# It's not needed to remove the class since the body will be overwritten