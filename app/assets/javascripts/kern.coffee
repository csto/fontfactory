window.app.factory 'Kern', ($rootScope) ->
  class Kern
    constructor: (char) ->
      @paper = Snap('#kern')
      @g = @paper.g()
      
    updateKern: (letters) ->
      @g.selectAll('*').remove()
      for char in $rootScope.characters
        if letters.indexOf(char.character) > -1
          @buildLetter(char)
      
    updatePosition: () ->
      
          
    buildLetter: (char) ->
      if char.paths
        for path in char.paths
          @g.path(path: path)
          