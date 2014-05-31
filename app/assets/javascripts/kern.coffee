window.app.factory 'Kern', ($rootScope) ->
  class Kern
    constructor: (char) ->
      $rootScope.kernSize = 40
      @paper = Snap('#kern')
      @updateSize($rootScope.kernSize)
      
    updateKern: (letters) ->
      @letters = letters
      @paper.selectAll('*').remove()
      @totalKern = 0
      for letter in @letters
        char = @getChar(letter)
        @buildLetter(char)
        
    updateSize: (kernSize) ->
      @sizeRatio = kernSize / $rootScope.font.ascent_height
      if @letters
        @updateKern(@letters)
      # add directive to everything to change size simply by updating $scope.sizeRatio
      
    selectCharacter: () ->
      # put square overlay over letter
      # click overlay to select
      # once selected, add line to right
      # drag line to change kern
      @paper.selectAll('')
      
          
    buildLetter: (letter) ->
      if letter.paths
        @g = @paper.g().transform("t#{@totalKern},0").click(
          (event) ->
            @paper.selectAll('line').attr("stroke-width": 0)
            this.selectAll('line').attr("stroke-width": 2)
          )
        
        @totalKern += (letter.kern || 1000) * @sizeRatio
        
        @g.rect(x: 0, y: 0, width: (letter.kern || 1000) * @sizeRatio, height: 1000 * @sizeRatio)
        for path in letter.paths
          @path = @g.g().transform("S#{@sizeRatio},#{@sizeRatio}")
          @path.path(path: path)
        
          
        @g.line(
            x1: (letter.kern || 1000) * @sizeRatio,
            x2: (letter.kern || 1000) * @sizeRatio,
            y1: 0,
            y2: 1000 * @sizeRatio
          ).drag(
            (dx, dy, x, y, e) =>
              console.log dx, dy
              # $rootScope.font.characters[char].kern = dx
            )
          
    getChar: (letter) ->
      for char in $rootScope.font.characters
        if letter == char.character
          return char
          
          
