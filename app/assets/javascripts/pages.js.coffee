#= require editor

window.name = ''
window.grid = 100
window.xHeight = 400
window.overshoot = 10
window.ascentHeight = 700
window.descentHeight = 300
window.lineGap = 250
window.character = 0

# $ ->
#   window.edit = new Edit(0)
#   
#   $(document).bind('keydown', 'q shift+q', ->
#       edit.setTool('select')
#     )
#   
#   $(document).bind('keydown', 'w shift+w', ->
#       edit.setTool('direct')
#     )
#   
#   $(document).bind('keydown', 'e shift+e', ->
#       edit.setTool('pen')
#     )
#   
#   $(document).bind('keydown', 'r shift+r', ->
#       edit.setTool('convert')
#     )
#   
#   $(document).bind('keydown', 't shift+t', ->
#       edit.setTool('pan')
#     )
#     
#   $('#zoom-in').click ->
#     newZoom = edit.zoom * 2
#     edit.paperZoom(newZoom)
#   
#   $('#zoom-out').click ->
#     newZoom = edit.zoom / 2
#     edit.paperZoom(newZoom)
#     
#   $('.tool').click ->
#     edit.setTool($(this).data('tool'))
#     
#   $('#editor').mousedown (e) ->
#     if !edit.draggingPoint
#       edit.dragging = true
#   
#       x = (e.pageX - $(this).offset().left)
#       y = (e.pageY - $(this).offset().top)
#   
#       if edit.tool == 'select'
#         edit.selectDown(e, x, y)
#   
#       if edit.tool == 'direct'
#         edit.directDown(e, x, y)
#   
#       if edit.tool == 'pen'
#         edit.penDown(e, x, y)
#   
#       if edit.tool == 'convert'
#         edit.convertDown(e, x, y)
#   
#       if edit.tool == 'pan'
#         edit.panDown(x, y)
#   
#   
#   $('#editor').mousemove (e) ->
#     x = (e.pageX - $(this).offset().left)
#     y = (e.pageY - $(this).offset().top)
#   
#     if edit.dragging && !edit.draggingPoint
#       if edit.tool == 'direct'
#         edit.directMove(x, y)
#   
#       if edit.tool == 'pen'
#         edit.penMove(e, x, y)
#   
#       if edit.tool == 'convert'
#         edit.convertMove(x, y)
#   
#       if edit.tool == 'pan'
#         edit.panMove(x, y)
#     else
#       if edit.tool == 'pen' && edit.el && !edit.creating
#         edit.setCursor(e, x, y)
#   
#   
#   $('#editor').mouseup (e) ->
#     edit.dragging = false
#   
#     if edit.tool == 'direct'
#       edit.directUp()
#   
#     if edit.tool == 'pen'
#       $('#editor-wrapper').removeClass('pen-add pen-remove')
#   
#     if edit.tool == 'pan'
#       edit.panUp()
#   
#     edit.save()
#   