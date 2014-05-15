window.app.factory 'Edit', ($rootScope, $http, $resource) ->
  class Edit
    constructor: () ->  
    
      $rootScope.tool = 'pen'
      $rootScope.zoom = .5
      $rootScope.viewbox = {x: -101, y: -101, w: 6000, h: 6000}
      
      @character = $rootScope.font.characters[$rootScope.char]
      @el = null
      @elPath = null
      @path = null
      @vertex = null
      @dragging = false
      @creating = false
      @point = null
      @point1 = null
      @point2 = null
      @line1 = null
      @line2 = null
      
      @pathCount = 0
      @undos = []
      @undoCount= 0
      
      @convertDragging = false
      @draggingPoint = false
      @draggingCorner
      @bBox = null
      @tBox = null
      @vnum = null
      @mouseX = null
      @mouseY = null

      @paper = Snap('#editor')
      @g = @paper.g()
      @grids = @g.g()
      @createGrid()
      
    createGrid: ->
      @grids.selectAll('*').remove()
      for i in [-20..30]
        @grids.line(i * $rootScope.font.grid, -9999, i * $rootScope.font.grid, 9999).attr('class', 'grid light')
        @grids.line(-9999, i * $rootScope.font.grid, 9999, i * $rootScope.font.grid).attr('class', 'grid light')
  
      @grids.line(0, -9999, 0, 9999).attr('class', 'grid grid-left')
      @grids.line(-9999, 0, 9999, 0).attr('class', 'grid grid-top')
      @grids.line(-9999, 1000, 9999, 1000).attr('class', 'grid grid-bottom')
      @grids.line(-9999, 700, 9999, 700).attr('class', 'grid grid-ascent')
      @grids.line(-9999, $rootScope.font.x_height, 9999, $rootScope.font.x_height).attr('class', 'grid grid-x-height')
      @grids.line(1000, -9999, 1000, 9999).attr('class', 'grid grid-width')
      
      if @character.paths
        for path in @character.paths
          @g.path(path)
        
      
    mousedown: (e) ->
      if !@draggingPoint && !@draggingCorner
        @dragging = true
  
        x = (e.offsetX / $rootScope.zoom) + $rootScope.viewbox.x
        y = (e.offsetY / $rootScope.zoom) + $rootScope.viewbox.y
        
        switch $rootScope.tool  
          when 'select'
            @selectDown(e, x, y)
          
          when 'direct'
            @directDown(e, x, y)
          
          when 'pen'
            @penDown(e, x, y)
          
          when 'convert'
            @convertDown(e, x, y)
          
          when 'pan'
            @panDown(x, y)
  
  
    mousemove: (e) ->
      x = (e.offsetX / $rootScope.zoom) + $rootScope.viewbox.x
      y = (e.offsetY / $rootScope.zoom) + $rootScope.viewbox.y
  
      if @dragging && !@draggingPoint && !@draggingCorner
        switch $rootScope.tool 
          when 'select'
            @selectMove(x, y)
           
          when 'direct'
            @directMove(x, y)
  
          when 'pen'
            @penMove(e, x, y)
  
          when 'convert'
            @convertMove(x, y)
  
          when 'pan'
            x = (e.offsetX / $rootScope.zoom)
            y = (e.offsetY / $rootScope.zoom)
            @panMove(x, y)
      else
        if $rootScope.tool == 'pen' && @el && !@creating
          @setCursor(e, x, y)
        else
          $rootScope.penClass = ''
  
  
    mouseup: (e) ->
      @dragging = false
      @convertDragging = false
  
      if $rootScope.tool == 'select'
        @selectUp()
        
      if $rootScope.tool == 'direct'
        @directUp()

      @save()
      
    paperZoom: (z) ->
      $rootScope.zoom *= z
      $rootScope.viewbox.x = $rootScope.viewbox.x / z  #Math.round($rootScope.viewbox.x) - (.5 / $rootScope.zoom)
      $rootScope.viewbox.y = $rootScope.viewbox.y / z  #Math.round($rootScope.viewbox.y) - (.5 / $rootScope.zoom)
      $rootScope.viewbox.w /= z
      $rootScope.viewbox.h /= z
      
      for el in Snap.selectAll('.grid, .el-path')
        el.attr('style', "stroke-width: #{1 / $rootScope.zoom}px")
      
      if @el && $rootScope.tool == 'select'
        @tSelect()
      else
        @selectEl()
        
  
    # flattenG: ->
    #   @el.attr("id", 'el') if @el
    #   @elPath.remove() if @elPath
    #   if @vertex
    #     vnum = @vertex.data("vertex")
    #   
    #   Snap.selectAll('rect, circle').remove()
    #   flatten(document.getElementById('editor'))
    #   @el = Snap.select('#el')
    #   @elPath = Snap.select('#elpath')
    #     
    #   @selectEl()
    #   @vertex = Snap.select("#vertex#{vnum}")
    #   @createPoints()
    
    setTool: (tool) ->
      @creating = false
      
      if $rootScope.tool == 'select'
        @clear()
        if @el
          @selectEl()
        
      $rootScope.tool = tool
      if $rootScope.tool == 'select' && @el
        @tSelect()
        
    setCursor: (e, x, y) ->
      $rootScope.penClass = ''
      selection = Snap.getElementByPoint(e.clientX, e.clientY)
    
      if selection.type == 'rect'
        $rootScope.penClass = 'pen-remove'
      else
        n1 = @g.path([["M", x - (3 / $rootScope.zoom), y], ["L", x + (3 / $rootScope.zoom), y]])
        n2 = @g.path([["M", x, y - (3 / $rootScope.zoom)], ["L", x, y + (3 / $rootScope.zoom)]])
        i1 = Snap.path.intersection(@el.attr("path"), n1)
        i2 = Snap.path.intersection(@el.attr("path"), n2)
        n1.remove()
        n2.remove()
        i = undefined
        if i1.length > 0
          i = i1[0]
        if i2.length > 0
          i = i2[0]
        if i != undefined
          $rootScope.penClass = 'pen-add'
    
    panDown: (x, y) ->
      @mouseX = x
      @mouseY = y
    
    panMove: (x, y) ->
      x = x - @mouseX
      y = y - @mouseY
      # @g.transform("t#{x},#{y}}")
      $rootScope.viewbox.x = -x
      $rootScope.viewbox.y = -y
    
    selectDown: (e, x, y) ->
      @mouseX = x
      @mouseY = y
      
      @deselect()
      selection = Snap.getElementByPoint(e.clientX, e.clientY)
    
      if selection.type == 'path' && !selection.attr('class') # grid lines have a class
        @el = selection
    
        @tSelect()
    
    tSelect: ->
      @clear()
      
      bb = @el.getBBox()
    
      @bBox = @g.rect(bb.x, bb.y, bb.w, bb.h).attr('class', 'bb').attr('style', "stroke-width: #{1 / $rootScope.zoom}px")
    
      @createCorners()
      
    clear: ->
      @vertex = null
      @point = null
      @point1 = null
      @point2 = null
      @line1 = null
      @line2 = null
      @elPath.remove() if @elPath
      Snap.selectAll('circle').remove()
      Snap.selectAll('rect').remove()
      Snap.selectAll('line:not(.grid)').remove()
      
    createCorners: ->
      Snap.selectAll('.corner').remove()
      bb = @bBox.getBBox()
      @tl = @g.rect(bb.x - (3 / $rootScope.zoom), bb.y - (3 / $rootScope.zoom),(6 / $rootScope.zoom),(6 / $rootScope.zoom)).attr(class: 'corner', style: "stroke-width: #{1 / $rootScope.zoom}px")
      @tm = @g.rect(bb.cx - (3 / $rootScope.zoom), bb.y - (3 / $rootScope.zoom),(6 / $rootScope.zoom),(6 / $rootScope.zoom)).attr(class: 'corner', style: "stroke-width: #{1 / $rootScope.zoom}px")
      @tr = @g.rect(bb.x + bb.w - (3 / $rootScope.zoom), bb.y - (3 / $rootScope.zoom),(6 / $rootScope.zoom),(6 / $rootScope.zoom)).attr(class: 'corner', style: "stroke-width: #{1 / $rootScope.zoom}px")
      @ml = @g.rect(bb.x - (3 / $rootScope.zoom), bb.cy - (3 / $rootScope.zoom),(6 / $rootScope.zoom),(6 / $rootScope.zoom)).attr(class: 'corner', style: "stroke-width: #{1 / $rootScope.zoom}px")
      @mr = @g.rect(bb.x + bb.w - (3 / $rootScope.zoom), bb.cy - (3 / $rootScope.zoom),(6 / $rootScope.zoom),(6 / $rootScope.zoom)).attr(class: 'corner', style: "stroke-width: #{1 / $rootScope.zoom}px")
      @bl = @g.rect(bb.x - (3 / $rootScope.zoom), bb.y + bb.h - (3 / $rootScope.zoom),(6 / $rootScope.zoom),(6 / $rootScope.zoom)).attr(class: 'corner', style: "stroke-width: #{1 / $rootScope.zoom}px")
      @bm = @g.rect(bb.cx - (3 / $rootScope.zoom), bb.y + bb.h - (3 / $rootScope.zoom),(6 / $rootScope.zoom),(6 / $rootScope.zoom)).attr(class: 'corner', style: "stroke-width: #{1 / $rootScope.zoom}px")
      @br = @g.rect(bb.x + bb.w - (3 / $rootScope.zoom), bb.y + bb.h - (3 / $rootScope.zoom),(6 / $rootScope.zoom),(6 / $rootScope.zoom)).attr(class: 'corner', style: "stroke-width: #{1 / $rootScope.zoom}px")
        
      @tr.drag(
          (dx, dy, x, y, e) =>
            @cornerDrag(dx, dy, x, y, e, @tr)
          =>
            @draggingCorner = true
            @width = @el.getBBox().w
            @height = @el.getBBox().h
          =>
            @draggingCorner = false
            @setTransform(@el)
        )
      
      # this is giving the wrong scope for rect in @cornerDrag()
      # for rect in [@tl, @tm, @tr, @ml, @mr, @bl, @bm, @br]
      #   @rect = rect
      #   rect.drag(
      #       (dx, dy, x, y, e) =>
      #         @cornerDrag(dx, dy, x, y, e, @rect)
      #       =>
      #         @draggingCorner = true
      #         @width = @el.getBBox().w
      #         @height = @el.getBBox().h
      #       =>
      #         @draggingCorner = false
      #         @setTransform(@el)
      #     )
    
      @tBox = Snap.set(@bBox, @tl, @tm, @tr, @ml, @mr, @bl, @bm, @br)
      
    cornerDrag: (dx, dy, x, y, e, rect) ->
      x = (e.offsetX / $rootScope.zoom) + $rootScope.viewbox.x 
      y = (e.offsetY / $rootScope.zoom) + $rootScope.viewbox.y
      
      bottom = @bBox.asPX('y') + @bBox.asPX('height')
      right = @bBox.asPX('x') + @bBox.asPX('width')
      # left = @bBox.asPX('x')
      # width = @bBox.asPX('width')
      # height = @bBox.asPX('height')
      
      # drag the selected corner
      rect.attr(x: x, y: y)
      
      if rect == @tl
        @bBox.attr(
            width: x,
            height: bottom - y,
            x: x
          )
      
      if rect == @tr
        @bBox.attr(
            width: x - @bBox.asPX('x'),
            height: bottom - y,
            y: y
          )
      
      @createCorners()
      
      bb = @el.getBBox()
      w = (x - bb.x) / @width
      h = (bottom - y) / @height
      @el.transform("s#{w},#{h},#{@bBox.asPX('x')}, #{bottom}")
    
    
    selectMove: (x, y) ->
      x = x - @mouseX
      y = y - @mouseY
      
      @tBox.forEach (element) ->
        element.transform("t#{x},#{y}")
      @el.transform("t#{x},#{y}")
      
    selectUp: ->
      if @el
        @setTransform(@el)
      if @tBox
        @tBox.forEach (element) =>
          @setTransform(element)
    
    deselect: ->
      if @el
        @el.attr("id", '')
        @el = null
        
      @clear()
    
    selectEl: ->
      if @el
        Snap.selectAll('circle').remove()
        Snap.selectAll('rect').remove()
        Snap.selectAll('line:not(.grid)').remove()
        if @vertex
          vnum = @vertex.data("vertex")
        @path = @pathArray(@el)
        @setElPath()
        for item, index in @path
          if item[0] == "C" && index != @path.length - 1
            vertex = @g.rect(
                item[5] - (3 / $rootScope.zoom),
                item[6] - (3 / $rootScope.zoom),
                (6 / $rootScope.zoom),
                (6 / $rootScope.zoom)
              ).data("vertex", index).attr(id: "vertex#{index}", style: "stroke-width: #{1 / $rootScope.zoom}px")
            if index == vnum
              vertex.attr('id', 'vertex')
              @createPoints()
        
    
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
        Snap.select('#vertex').attr('id', '') if Snap.select('#vertex')
        @vertex.attr('id', 'vertex')
        
        @createPoints()
        @dragging = true
    
    
    directMove: (x, y) ->
      if @vertex
        set = Snap.set(@vertex, @point1, @point2, @line1, @line2)
    
        diffX = x - @vertex.asPX("x") - (3 / $rootScope.zoom)
        diffY = y - @vertex.asPX("y") - (3 / $rootScope.zoom)
    
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
        @path = Snap.path.map(element.attr("path"), t.localMatrix)
        element.attr("path", @path)
    
      if element.type == 'rect'
        element.attr(
            x: element.asPX("x") + t.localMatrix.e,
            y: element.asPX("y") + t.localMatrix.f
          )
    
      if element.type == 'circle'
        element.attr(
            cx: element.asPX("cx") + t.localMatrix.e,
            cy: element.asPX("cy") + t.localMatrix.f
          )
    
      if element.type == 'line'
        element.attr(
            x1: element.asPX("x1") + t.localMatrix.e,
            y1: element.asPX("y1") + t.localMatrix.f,
            x2: element.asPX("x2") + t.localMatrix.e,
            y2: element.asPX("y2") + t.localMatrix.f
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
          @point2 = @g.circle(@path[@path.length - 1][3], @path[@path.length - 1][4], (3 / $rootScope.zoom))
          @point1 = @g.circle(@path[vnum + 1][1], @path[vnum + 1][2], (3 / $rootScope.zoom))
        else
          @point2 = @g.circle(@path[vnum][3], @path[vnum][4], (3 / $rootScope.zoom))
          @point1 = @g.circle(@path[vnum + 1][1], @path[vnum + 1][2], (3 / $rootScope.zoom))
    
        @el.after(@point1)
        @el.after(@point2)
    
        @point1.drag(
            (dx, dy, x, y, e) =>
              @pointDrag(dx, dy, x, y, e, @point1)
            =>
              @draggingPoint = true
            =>
              @draggingPoint = false
          )
    
        @point2.drag(
            (dx, dy, x, y, e) =>
              @pointDrag(dx, dy, x, y, e, @point2)
            =>
              @draggingPoint = true
            =>
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
              x2: @vertex.asPX('x') + (3 / $rootScope.zoom),
              y2: @vertex.asPX('y') + (3 / $rootScope.zoom)
            ).attr('style', "stroke-width: #{1 / $rootScope.zoom}px")
        else
          @line1 = @g.line(
              @point1.asPX('cx'),
              @point1.asPX('cy'),
              @vertex.asPX('x') + (3 / $rootScope.zoom),
              @vertex.asPX('y') + (3 / $rootScope.zoom)
            )
    
        if @line2
          @line2.attr(
              x1: @point2.asPX('cx'),
              y1: @point2.asPX('cy'),
              x2: @vertex.asPX('x') + (3 / $rootScope.zoom),
              y2: @vertex.asPX('y') + (3 / $rootScope.zoom)
            )
        else
          @line2 = @g.line(
              @point2.asPX('cx'),
              @point2.asPX('cy'),
              @vertex.asPX('x') + (3 / $rootScope.zoom),
              @vertex.asPX('y') + (3 / $rootScope.zoom)
            )
    
        @el.after(@line1)
        @el.after(@line2)
    
    
    pointDrag: (dx, dy, x, y, e, point) ->
      @point = point
      vnum = @vertex.data("vertex")
      
      x = (e.offsetX / $rootScope.zoom) + $rootScope.viewbox.x 
      y = (e.offsetY / $rootScope.zoom) + $rootScope.viewbox.y 
      
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
      @convertDragging = true
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
        Snap.select('#vertex').attr('id', '') if Snap.select('#vertex')
        @vertex.attr('id', 'vertex')
    
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
        n1 = @g.path([["M", x - (3 / $rootScope.zoom), y], ["L", x + (3 / $rootScope.zoom), y]])
        n2 = @g.path([["M", x, y - (3 / $rootScope.zoom)], ["L", x, y + (3 / $rootScope.zoom)]])
        i1 = Snap.path.intersection(@el.attr("path"), n1)
        i2 = Snap.path.intersection(@el.attr("path"), n2)
        n1.remove()
        n2.remove()
        i = undefined
        if i1.length > 0
          i = i1[0]
        if i2.length > 0
          i = i2[0]
        if i
          @g.rect(x - (3 / $rootScope.zoom), y - (3 / $rootScope.zoom),(6 / $rootScope.zoom),(6 / $rootScope.zoom))
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
        Snap.select('#vertex').attr('id', '') if Snap.select('#vertex')
        @vertex.attr('id', 'vertex')
        
        @convertDragging = true
        @createPoints()
    
      # if selection.type == 'circle'
      #   point = selection
    
    convertMove: (x, y) ->
      if @vertex && @convertDragging # && !@point
        @path = @pathArray(@el)
    
        ix = -(x - @vertex.asPX('x') - (3 / $rootScope.zoom)) + @vertex.asPX('x') + (3 / $rootScope.zoom)
        iy = -(y - @vertex.asPX('y') - (3 / $rootScope.zoom)) + @vertex.asPX('y') + (3 / $rootScope.zoom)
    
        if !@point1 || !@point2
          @createPoints()
    
        @point1.attr("cx", x).attr("cy", y)
        @point2.attr("cx", ix).attr("cy", iy)
    
        @updateVertex(
            ix,
            iy,
            x,
            y,
            @vertex.asPX("x") + (3 / $rootScope.zoom),
            @vertex.asPX("y") + (3 / $rootScope.zoom)
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
      @pathCount++
      @creating = true
      @el = @g.path([
          ["M", x, y],
          ["C", x, y, x, y, x, y],
          ["C", x, y, x, y, x, y]
        ]) #.attr(class: "el#{@pathCount}")
      @path = @pathArray()
      @setElPath()
      @vertex = @g.rect(
          x - (3 / $rootScope.zoom),
          y - (3 / $rootScope.zoom),
          (6 / $rootScope.zoom),
          (6 / $rootScope.zoom)
        ).data("vertex", 1).attr(style: "stroke-width: #{1 / $rootScope.zoom}px")
      Snap.select('#vertex').attr('id', '') if Snap.select('#vertex')
      @vertex.attr('id', 'vertex')
    
    appendToPath: (x, y) ->
      @path = @pathArray(@el)
      endVertex = @path.pop()
      @path.push(
          ["C", endVertex[1], endVertex[2], x, y, x, y],
          endVertex
        )
      endVertex[1] = x
      endVertex[2] = y
      @el.attr(path: @path)
      @setElPath()
      @vertex = @g.rect(
          x - (3 / $rootScope.zoom),
          y - (3 / $rootScope.zoom),
          (6 / $rootScope.zoom),(6 / $rootScope.zoom)
        ).data("vertex", @path.length - 2).attr(style: "stroke-width: #{1 / $rootScope.zoom}px")
      Snap.select('#vertex').attr('id', '') if Snap.select('#vertex')
      @vertex.attr('id', 'vertex')
    
    pathArray: ->
      @path = Snap.path.toAbsolute(@el.attr("path"))
      @path
    
    
    save: ->
      console.log 'saving'
      if @el
        @el.attr("path", @path)
        $rootScope.font.characters[$rootScope.char].paths = []
        $rootScope.font.characters[$rootScope.char].absolutePaths = []
        for path in Snap.selectAll('#editor > g > path:not(.el-path)')
          $rootScope.font.characters[$rootScope.char].paths.push(Snap.parsePathString(path.attr("path")))
          $rootScope.font.characters[$rootScope.char].absolutePaths.push(path.attr("path"))
          
        $rootScope.font.$update(
          (u) ->
            console.log u 
            $rootScope.font.characters = angular.fromJson(u.characters)
        )
          
    undo: ->
      @undoCount--
      @g.selectAll('*').remove()
      for path, index in @undos[@undoCount].paths
        @g.path(path).attr(class: "el#{index}")
      
      
    redo: ->
      console.log 'redo'
    
    
