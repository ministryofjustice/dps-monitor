class Dashing.ServerStatusSquares extends Dashing.Widget

  onData: (data) ->
    $(@node).fadeOut().fadeIn()
    result = data.result
    green = 191 - (result.outofdate ? 0)
    red = "#BF4848"
    color = if result.status then "rgb(150, #{green}, 72)" else red
    $(@get('node')).css('background-color', "#{color}")
