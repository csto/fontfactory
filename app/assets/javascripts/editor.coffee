class window.Edit
  constructor: (@char) ->  
    @tool = 'pen'
    @el = null
    @elPath = null
    @path = null
    @vertex = null
    @zoom = .5
    @dragging = false
    @creating = false
    @point = null
    @point1 = null
    @point2 = null
    @line1 = null
    @line2 = null

    @draggingPoint = false
    @bBox = null
    @tBox = null
    @vnum = null
    @panX = null
    @panY = null

    $('#editor').html('')
    @paper = Snap('#editor')
    @g = @paper.g()
    @grids = @g.g()
  
    for i in [-20..30]
      @grids.line(i * window.grid, -9999, i * window.grid, 9999).attr('class', 'grid light')
      @grids.line(-9999, i * window.grid, 9999, i * window.grid).attr('class', 'grid light')
  
    @grids.line(0, -9999, 0, 9999).attr('class', 'grid grid-left')
    @grids.line(-9999, 0, 9999, 0).attr('class', 'grid grid-top')
    @grids.line(-9999, 1000, 9999, 1000).attr('class', 'grid grid-bottom')
    @grids.line(-9999, 700, 9999, 700).attr('class', 'grid grid-ascent')
    @grids.line(-9999, 300, 9999, 300).attr('class', 'grid grid-x-height')
    @grids.line(1000, -9999, 1000, 9999).attr('class', 'grid grid-width')
    
    @paperZoom(.25)
    @g.transform("t50.5,50.5")
    @flattenG()
      
  paperZoom: (newZoom) ->
    z = newZoom / @zoom
    @zoom = newZoom
    @g.transform("s#{z},#{z}")
    @flattenG()
    $('#zoom').html("#{@zoom * 100}%")

  flattenG: ->
    @el.attr("id", 'el') if @el
    @elPath.remove() if @elPath
    if @vertex
      vnum = @vertex.data("vertex")
  
    Snap.selectAll('rect, circle').remove()
    flatten(document.getElementById('editor'))
    @el = Snap.select('#el')
    @elPath = Snap.select('#elpath')
      
    @selectEl()
    @vertex = Snap.select("#vertex#{vnum}")
    @createPoints()
  
  setTool: (t) ->
    @creating = false
    if @tool == 'select'
      @flattenG()  # this could be something more efficient
    @tool = $("##{t}").data("tool")
    $('.current').removeClass('current')
    $("##{t}").addClass('current')
    $('#editor-wrapper').removeClass('pen pan pen-add pen-remove direct select convert')
    $('#editor-wrapper').addClass(@tool)
    if @tool == 'select' && @el
      @tSelect()
      
  setCursor: (e, x, y) ->
    selection = Snap.getElementByPoint(e.clientX, e.clientY)
  
    if selection.type == 'rect'
      $('#editor-wrapper').addClass('pen-remove')
    else
      n1 = @g.path([["M", x - 3, y], ["L", x + 3, y]])
      n2 = @g.path([["M", x, y - 3], ["L", x, y + 3]])
      i1 = Snap.path.intersection(@el.attr("path"), n1)
      i2 = Snap.path.intersection(@el.attr("path"), n2)
      i = null
      if i1.length > 0
        i = i1[0]
      if i2.length > 0
        i = i2[0]
      if $.isPlainObject(i)
        $('#editor-wrapper').addClass('pen-add')
      else
        $('#editor-wrapper').removeClass('pen-add pen-remove')
  
  panDown: (x, y) ->
    @panX = x
    @panY = y
  
  panMove: (x, y) ->
    x = x - @panX
    y = y - @panY
    @g.transform("t#{x},#{y}}")
  
  panUp: ->
    @flattenG()
  
  selectDown: (e, x, y) ->
    @deselect()
    selection = Snap.getElementByPoint(e.clientX, e.clientY)
  
    if selection.type == 'path' && !selection.attr('class') # grid lines have a class
      @el = selection
  
      @tSelect()
  
  tSelect: ->
    bb = @el.getBBox()
  
    bBox = @g.rect(bb.x, bb.y, bb.w, bb.h).attr('class', 'bb')
  
    bBox.drag(
        (dx, dy, x, y, e) =>
          @bBoxDrag(dx, dy, x, y, bBox)
        ->
        =>
          for element in @tBox
            @setTransform(element)
          @setTransform(@el)
          @path = Snap.path.toAbsolute(@el.attr("path"))
      )
  
    tl = @g.rect(bb.x - 3, bb.y - 3, 6, 6)
    tm = @g.rect(bb.cx, bb.y - 3, 6, 6)
    tr = @g.rect(bb.x + bb.w - 3, bb.y - 3, 6, 6)
    ml = @g.rect(bb.x - 3, bb.cy, 6, 6)
    mr = @g.rect(bb.x + bb.w - 3, bb.cy, 6, 6)
    bl = @g.rect(bb.x - 3, bb.y + bb.h - 3, 6, 6)
    bm = @g.rect(bb.cx, bb.y + bb.h - 3, 6, 6)
    br = @g.rect(bb.x + bb.w - 3, bb.y + bb.h - 3, 6, 6)
  
    tr.drag(
        (dx, dy, x, y, e) ->
          @cornerDrag(dx, dy, x, y, bBox, tr)
      )
  
    @tBox = Snap.set(bBox, tl, tm, tr, ml, mr, bl, bm, br)
  
  
  bBoxDrag: (dx, dy, x, y, bBox) ->
    x = x - $('#editor').offset().left
    y = y - $('#editor').offset().top
  
    @tBox.forEach (element) ->
      element.transform("t#{dx},#{dy}")
    @el.transform("t#{dx},#{dy}")
  
  cornerDrag: (dx, dy, x, y, bBox, tr) ->
  
  
  deselect: ->
    if @el
      @el.attr("id", '')
      @el = null
    @vertex = null
    @point = null
    @point1 = null
    @point2 = null
    @line1 = null
    @line2 = null
    @elPath.remove() if @elPath
    $('circle').remove()
    $('rect').remove()
    $('line').remove()
  
  selectEl: ->
    if @el
      @vertex = null
      $('circle').remove()
      $('rect').remove()
      $('line').remove()
      @path = @pathArray(@el)
      @setElPath()
      for item, index in @path
        if item[0] == "C" && index != @path.length - 1
          @g.rect(item[5] - 3, item[6] - 3, 6, 6).data("vertex", index).attr("id", "vertex#{index}")
  
  directDown: (e, x, y) ->
    selection = Snap.getElementByPoint(e.clientX, e.clientY)
  
    if selection.type == 'svg'
      @deselect()
  
    if selection.type == 'path' && !selection.attr('class') # grid lines have a class
      @deselect()
      @el = selection
      @selectEl()
  
    if selection.type == 'rect'
      @vertex = selection
      @createPoints()
      @dragging = true
  
  
  directMove: (x, y) ->
    if @vertex
      set = Snap.set(@vertex, @point1, @point2, @line1, @line2)
  
      diffX = x - @vertex.asPX("x") - 3
      diffY = y - @vertex.asPX("y") - 3
  
      set.forEach (element) ->
        element.transform("t#{diffX},#{diffY}")
  
      @updateVertex(@point2.asPX("cx") + diffX, @point2.asPX("cy") + diffY, @point1.asPX("cx") + diffX, @point1.asPX("cy") + diffY, x, y)
  
  directUp: ->
    if @vertex
      @setTransform(@vertex)
      @setTransform(@point1)
      @setTransform(@point2)
      @setTransform(@line1)
      @setTransform(@line2)
  
  setTransform: (element) ->
    t = element.transform()
  
    if element.type == 'path'
      element.attr("path", Snap.path.map(element.attr("path"), t.globalMatrix))
  
    if element.type == 'rect'
      element.attr(
          x: element.asPX("x") + t.globalMatrix.e,
          y: element.asPX("y") + t.globalMatrix.f
        )
  
    if element.type == 'circle'
      element.attr(
          cx: element.asPX("cx") + t.globalMatrix.e,
          cy: element.asPX("cy") + t.globalMatrix.f
        )
  
    if element.type == 'line'
      element.attr(
          x1: element.asPX("x1") + t.globalMatrix.e,
          y1: element.asPX("y1") + t.globalMatrix.f,
          x2: element.asPX("x2") + t.globalMatrix.e,
          y2: element.asPX("y2") + t.globalMatrix.f
        )
  
    element.transform("t0,0")
  
  createPoints: ->
    if @vertex
      vnum = @vertex.data('vertex')
      if @point1
        @point1.remove()
      if @point2
        @point2.remove()
  
      if vnum == 1
        @point2 = @g.circle(@path[@path.length - 1][3], @path[@path.length - 1][4], 3)
        @point1 = @g.circle(@path[vnum + 1][1], @path[vnum + 1][2], 3)
      else
        @point2 = @g.circle(@path[vnum][3], @path[vnum][4], 3)
        @point1 = @g.circle(@path[vnum + 1][1], @path[vnum + 1][2], 3)
  
      @el.after(@point1)
      @el.after(@point2)
  
      @point1.drag(
          (dx, dy, x, y, e) =>
            @pointDrag(dx, dy, x, y, e, @point1)
          ->
            @draggingPoint = true
          ->
            @draggingPoint = false
        )
  
      @point2.drag(
          (dx, dy, x, y, e) =>
            @pointDrag(dx, dy, x, y, e, @point2)
          ->
            @draggingPoint = true
          ->
            @draggingPoint = false
        )
  
      @setLines()

  setElPath: ->
    if @el
      if @elPath
        @elPath.attr('path', @path)
      else
        @elPath = @g.path(@path).attr('class', 'el-path')
  
      @el.after(@elPath)
  
  setLines: ->
    if @vertex
      if @line1
        @line1.attr(
            x1: @point1.asPX('cx'),
            y1: @point1.asPX('cy'),
            x2: @vertex.asPX('x') + 3,
            y2: @vertex.asPX('y') + 3
          )
      else
        @line1 = @g.line(
            @point1.asPX('cx'),
            @point1.asPX('cy'),
            @vertex.asPX('x') + 3,
            @vertex.asPX('y') + 3
          )
  
      if @line2
        @line2.attr(
            x1: @point2.asPX('cx'),
            y1: @point2.asPX('cy'),
            x2: @vertex.asPX('x') + 3,
            y2: @vertex.asPX('y') + 3
          )
      else
        @line2 = @g.line(
            @point2.asPX('cx'),
            @point2.asPX('cy'),
            @vertex.asPX('x') + 3,
            @vertex.asPX('y') + 3
          )
  
      @el.after(@line1)
      @el.after(@line2)
  
  
  pointDrag: (dx, dy, x, y, e, point) ->
    @point = point
    vnum = @vertex.data("vertex")
  
    x = x - $('#editor').offset().left
    y = y - $('#editor').offset().top
  
    @point.attr(
        cx: x,
        cy: y
      )
  
    if @point1 == point
      @path[vnum + 1][1] = x
      @path[vnum + 1][2] = y
  
    if @point2 == point
      if vnum == 1
        @path[@path.length - 1][3] = x
        @path[@path.length - 1][4] = y
      else
        @path[vnum][3] = x
        @path[vnum][4] = y
  
    @setElPath()
    @setLines()
  
  penDown: (e, x, y) ->
    if !@el
      @createPath(x, y)
    else
      if @creating
        @appendToPath(x, y)
      else
        @addOrRemoveVertex(e, x, y)
  
  penMove: (e, x, y) ->
    @convertMove(x, y)
  
  
  removePath: ->
    @el.remove()
    @deselect()
  
  addOrRemoveVertex: (e, x, y) ->
    selection = Snap.getElementByPoint(e.clientX, e.clientY)
    if selection.type == 'rect'
      @vertex = selection
  
      if @path.length < 4
        @removePath()
      else
        vnum = @vertex.data("vertex")
        newPath = []
  
        for item, index in @path
          if index != vnum
            newPath.push(item)
  
        if vnum == 1
          @path = newPath
          @path[0][1] = @path[1][1]
          @path[0][2] = @path[1][2]
          @updateVertex(
              @path[1][3],
              @path[1][4],
              @path[2][1],
              @path[2][2],
              @path[1][5],
              @path[1][6]
            )
        else
          newPath[vnum][1] = @path[vnum][1]
          newPath[vnum][2] = @path[vnum][2]
          @path = newPath
  
        @el.attr("path", @path )
        @selectEl()
  
    else
      n1 = @g.path([["M", x - 3, y], ["L", x + 3, y]])
      n2 = @g.path([["M", x, y - 3], ["L", x, y + 3]])
      i1 = Snap.path.intersection(@el.attr("path"), n1)
      i2 = Snap.path.intersection(@el.attr("path"), n2)
      i = null
      if i1.length > 0
        i = i1[0]
      if i2.length > 0
        i = i2[0]
      if $.isPlainObject(i)
        @g.rect(x - 3, y - 3, 6, 6)
        newPath = []
        for item, index in @path
          if index == i.segment1
            newPath.push([
                "C",
                @path[index - 1][5],
                @path[index - 1][6],
                i.x,
                i.y,
                i.x,
                i.y
              ])
            newPath.push([
                "C",
                i.x,
                i.y,
                item[5],
                item[6],
                item[5],
                item[6]
              ])
          else
            newPath.push(item)
        @path = newPath
        @el.attr("path", @path)
        @selectEl()
      else
        @deselect()
  
  convertDown: (e, x, y) ->
    @point = null
  
    selection = Snap.getElementByPoint(e.clientX, e.clientY)
    if selection.type == 'rect'
      @vertex = selection
      @createPoints()
  
    # if selection.type == 'circle'
    #   point = selection
  
  convertMove: (x, y) ->
    if @vertex && !@point
      @path = @pathArray(@el)
  
      ix = -(x - @vertex.asPX('x') - 3) + @vertex.asPX('x') + 3
      iy = -(y - @vertex.asPX('y') - 3) + @vertex.asPX('y') + 3
  
      if !@point1 || !@point2
        @createPoints()
  
      @point1.attr("cx", x).attr("cy", y)
      @point2.attr("cx", ix).attr("cy", iy)
  
      @updateVertex(
          ix,
          iy,
          x,
          y,
          @vertex.asPX("x") + 3,
          @vertex.asPX("y") + 3
        )
  
      @setLines()
    
  updateVertex: (bX, bY, aX, aY, x, y) ->
    vnum = @vertex.data("vertex")
    vlast = @path.length - 1
  
    @path[vnum][5] = x
    @path[vnum][6] = y
    if vnum == 1
      @path[0][1] = x
      @path[0][2] = y
      @path[vnum][1] = x
      @path[vnum][2] = y
      @path[vnum][3] = x
      @path[vnum][4] = y
      @path[vnum + 1][1] = aX
      @path[vnum + 1][2] = aY
      @path[vlast][3] = bX
      @path[vlast][4] = bY
      @path[vlast][5] = x
      @path[vlast][6] = y
    else
      @path[vnum][3] = bX
      @path[vnum][4] = bY
      @path[vnum + 1][1] = aX
      @path[vnum + 1][2] = aY
  
    @setElPath()  
  
  createPath: (x, y) ->
    @creating = true
    @el = @g.path([
        ["M", x, y],
        ["C", x, y, x, y, x, y],
        ["C", x, y, x, y, x, y]
      ])
    @path = @pathArray()
    @setElPath()
    @vertex = @g.rect(x - 3, y - 3, 6, 6).data("vertex", 1)
  
  appendToPath: (x, y) ->
    @path = @pathArray(@el)
    endVertex = @path.pop()
    @path.push(
        ["C", endVertex[1], endVertex[2], x, y, x, y],
        endVertex
      )
    endVertex[1] = x
    endVertex[2] = y
    @el.attr("path", @path)
    @setElPath()
    @vertex = @g.rect(x - 3, y - 3, 6, 6).data("vertex", @path.length - 2)
  
  pathArray: ->
    @path = Snap.path.toAbsolute(@el.attr("path"))
    @path
  
  
  save: ->
    if @el
      @el.attr("path", @path)
  
  
