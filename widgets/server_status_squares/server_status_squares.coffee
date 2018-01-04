class Dashing.ServerStatusSquares extends Dashing.Widget

  onData: (data) ->
    $(@node).fadeOut().fadeIn()
    green = "#96BF48"
    red = "#BF4848"
    result = JSON.parse(data.result)
    color = if result.api.status is 'UP' then green else red
    $(@get('node')).css('background-color', "#{color}")