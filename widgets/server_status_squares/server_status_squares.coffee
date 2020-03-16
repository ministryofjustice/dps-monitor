class Dashing.ServerStatusSquares extends Dashing.Widget

  onData: (data) ->
    $(@node).fadeOut().fadeIn()
    result = data.result
    green = 191 - (result.outofdate ? 0)
    blue = 100 + (result.outofdate ? 0)
    color = if result.status then "rgb(150, #{green}, #{blue})" else "#BF4848"
    $(@get('node')).css('background-color', "#{color}")
