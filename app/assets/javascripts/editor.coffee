tool = 'pen'
el = null
path = null
vertex = null
zoom = 1
dragging = false
creating = false
point1 = null
point2 = null


$ ->
  paper = Snap('#editor')
  
  $('.tool').click ->
    creating = false
    tool = $(this).data("tool")
  
  $('#editor').mousedown (e) ->
    dragging = true
    
    x = (e.pageX - $(this).offset().left) / zoom
    y = (e.pageY - $(this).offset().top) / zoom
    
    if tool == 'direct'
      directDown(e, x, y)
      
    if tool == 'pen'
      penDown(e, x, y)
  
      
  $('#editor').mousemove (e) ->
    if dragging 
      x = (e.pageX - $(this).offset().left) / zoom
      y = (e.pageY - $(this).offset().top) / zoom
    
      if tool == 'direct'
        directMove(x, y)
      
      if tool == 'pen'
        penMove(x, y)
      
  $('#editor').mouseup (e) ->
    dragging = false
    
    if tool == 'direct'
      directUp()
    
    if tool == 'pen'
      penUp()
      
  
  deselect = ->
    el = null
    vertex = null
    $('circle').remove()
    $('rect').remove()
    
  selectEl = ->
    path = pathArray(el)
    for item, index in path
      if item[0] == "C" && index != path.length - 1
        paper.rect(item[5] - 3, item[6] - 3, 6, 6).data("vertex", index)

  getEl = (e) ->
  
  
  
  directDown = (e, x, y) ->
    selection = Snap.getElementByPoint(e.clientX, e.clientY)
    
    if selection.type == 'svg'
      deselect()
      
    if selection.type == 'path'
      deselect()
      el = selection
      selectEl()
    
    if selection.type == 'rect'
      vertex = selection
      createPoints()
      dragging = true
      
      
  directMove = (x, y) ->
    if dragging && vertex
      set = Snap.set(vertex, point1, point2)
      
      diffX = x - vertex.asPX("x") - 3
      diffY = y - vertex.asPX("y") - 3
      
      set.forEach (element) ->
        element.transform("t#{diffX},#{diffY}")
      
      updateVertex(vertex, point1.asPX("cx") + diffX, point1.asPX("cy") + diffY, point2.asPX("cx") + diffX, point2.asPX("cy") + diffY, x, y)
    
  directUp = ->
    if vertex
      t = vertex.transform()
      vertex.attr(
          x: vertex.asPX("x") + t.globalMatrix.e,
          y: vertex.asPX("y") + t.globalMatrix.f
        )
      vertex.transform("t0,0")

  createPoints = ->
    vnum = vertex.data('vertex')
    if point1
      point1.remove()
    if point2
      point2.remove()
      
    if vnum == 1
      point1 = paper.circle(path[path.length - 1][3], path[path.length - 1][4], 3)
      point2 = paper.circle(path[vnum + 1][1], path[vnum + 1][2], 3)
    else
      point1 = paper.circle(path[vnum][3], path[vnum][4], 3)
      point2 = paper.circle(path[vnum + 1][1], path[vnum + 1][2], 3)
    
    el.after(point1)
    el.after(point2)
  
  penDown = (e, x, y) ->
    if !el
      createPath(x, y)
    else
      if creating
        appendToPath(x, y)
      else
        addOrRemoveVertex(e, x, y)
      
  penMove = (x, y) ->
    convertMove(x, y)
    
  penUp = ->

    
  addOrRemoveVertex = (e, x, y) ->
    selection = Snap.getElementByPoint(e.clientX, e.clientY)
    if selection && selection.type == 'rect'
      console.log 'remove this vertex'
    else
      n1 = paper.path([["M", x - 3, y], ["L", x + 3, y]])
      n2 = paper.path([["M", x, y - 3], ["L", x, y + 3]])
      i1 = Snap.path.intersection(el.attr("path"), n1)
      i2 = Snap.path.intersection(el.attr("path"), n2)
      if i1.length > 0
        i = i1[0]
      if i2.length > 0
        i = i2[0]
      if i
        paper.rect(x - 3, y - 3, 6, 6)
        newPath = []
        for item, index in path
          if index == i.segment1
            newPath.push(["C", path[index - 1][5], path[index - 1][6], x, y, x, y])
          newPath.push(item)
        path = newPath
        el.attr("path", path)
    
    
  convertMove = (x, y) ->
    path = pathArray(el)
    
    ix = -(x - vertex.asPX('x') - 3) + vertex.asPX('x') + 3
    iy = -(y - vertex.asPX('y') - 3) + vertex.asPX('y') + 3
  
    if !point1 || !point2
      createPoints()
  
    point1.attr("cx", x).attr("cy", y)
    point2.attr("cx", ix).attr("cy", iy)
  
    updateVertex(
        vertex,
        ix,
        iy,
        x,
        y,
        vertex.asPX("x") + 3,
        vertex.asPX("y") + 3
      )
    
    
    
  updateVertex = (vertex, bX, bY, aX, aY, x, y) ->
    vnum = vertex.data("vertex")
    vlast = path.length - 1
    
    path[vnum][5] = x
    path[vnum][6] = y
    if vnum == 1
      path[0][1] = x
      path[0][2] = y
      path[vnum][1] = x
      path[vnum][2] = y
      path[vnum][3] = x
      path[vnum][4] = y
      path[vnum + 1][1] = aX
      path[vnum + 1][2] = aY
      path[vlast][3] = bX
      path[vlast][4] = bY
      # path[vlast - 1][1] = aX
      # path[vlast - 1][2] = aY
      path[vlast][5] = x
      path[vlast][6] = y
    else
      path[vnum][3] = bX
      path[vnum][4] = bY
      path[vnum + 1][1] = aX
      path[vnum + 1][2] = aY
  
    el.attr("path", path)
      
  
  createPath = (x, y) ->
    creating = true
    el = paper.path([
        ["M", x, y],
        ["C", x, y, x, y, x, y],
        ["C", x, y, x, y, x, y]
      ])
    vertex = paper.rect(x - 3, y - 3, 6, 6).data("vertex", 1)

  appendToPath = (x, y) ->
    path = pathArray(el)
    endVertex = path.pop()
    path.push(
        ["C", endVertex[1], endVertex[2], x, y, x, y],
        endVertex 
      )
    endVertex[1] = x
    endVertex[2] = y
    el.attr("path", path)
    vertex = paper.rect(x - 3, y - 3, 6, 6).data("vertex", path.length - 2)
    
  pathArray = (el) ->
    path = Snap.path.toAbsolute(el.attr("path"))
    path