class Dashing.ServerStatusSquares extends Dashing.Widget

  onData: (data) ->
    $(@node).fadeOut().fadeIn()
    green = "#96BF48"
    red = "#BF4848"
    result = data.result
    color = if result.status then green else red
    $(@get('node')).css('background-color', "#{color}")