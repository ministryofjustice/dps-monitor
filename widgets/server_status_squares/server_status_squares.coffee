class Dashing.ServerStatusSquares extends Dashing.Widget

  onData: (data) ->
    $(@node).fadeOut().fadeIn()
    result = data.result
    green = if result.outofdate then "#BFB452" else "#96BF48"
    red = "#BF4848"
    color = if result.status then green else red
    $(@get('node')).css('background-color', "#{color}")
