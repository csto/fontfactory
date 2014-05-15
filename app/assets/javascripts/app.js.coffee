window.app = angular.module('app', ['angular.ujs', 'ngResource', 'drahak.hotkeys', "ui.bootstrap"])

window.app.factory 'Font', ($resource) ->
  $resource(
    "/fonts/:id.json", 
    {id: "@id"},
    {
      get:
        isArray: false
        transformResponse: (data, headersGetter) ->
          console.log "Response: converting from json to objects"
          data = angular.fromJson(data)
          chars = angular.fromJson(data.characters)
          data.characters = chars
          return data
          
      update: 
        method: "PATCH"
        # transformRequest: (data, headersGetter) ->
        #   console.log 'Request: converting to json from objects'
        #   chars = angular.toJson(data.characters)
        #   data.characters = chars
        #   data = angular.toJson(data)
        #   return data
          
        # transformResponse: (data, headersGetter) ->
        #   console.log 'Response: converting from json to objects'
        #   console.log data + 'response'
        #   data = angular.fromJson(data)
        #   console.log data + 'test'
        #   chars = angular.fromJson(data.characters)
        #   data.characters = chars
        #   console.log data
        #   return data
    }
  )

window.app.controller 'tabCtrl', ($scope) ->
  $scope.tab = 'editor'
  
  $scope.setTab = (tab) ->
    $scope.tab = tab
    
dropdownCTRL = ($scope) ->
  
  $scope.status = isopen: false
  
  $scope.toggleDropdown = ($event) ->
    $event.preventDefault()
    $event.stopPropagation()
    $scope.status.isopen = not $scope.status.isopen

window.app.controller 'appCtrl', ($scope, $rootScope, $timeout, Edit, Kern, Font) ->
  
  # $rootScope.font = {}
  # $rootScope.font.name = ''
  # $rootScope.font.grid = 100
  # $rootScope.font.xHeight = 400
  # $rootScope.font.overshoot = 10
  # $rootScope.font.ascentHeight = 700
  # $rootScope.font.lineGap = 250
  
  $rootScope.char = 1
  $rootScope.fontId = $scope.fontId
  
  $timeout ->
    Font.get(id: $scope.fontId, (font) ->
        $rootScope.font = font
        # $rootScope.font.name = 'test font'
        # $rootScope.font.$update()
        # $rootScope.font.characters = angular.fromJson($rootScope.font.characters)
        $rootScope.edit = new Edit()
        $rootScope.kern = new Kern()
      )
  #   $rootScope.edit = new Edit(1)
  #   $rootScope.kern = new Kern()
    
  
  $scope.createGrid = ->
    $rootScope.edit.createGrid()
  
  $scope.setChar = (c) ->
    Snap.selectAll('#editor *').remove()
    $rootScope.char = c
    $rootScope.edit = new Edit()
  
  $scope.setTool = (tool) ->
    $rootScope.edit.setTool(tool)
    
  $scope.setZoom = (z) ->
    $rootScope.edit.paperZoom(z)
    
  $scope.mousedown = (e) ->
    $rootScope.edit.mousedown(e)
    
  $scope.mousemove = (e) ->
    $rootScope.edit.mousemove(e)
    
  $scope.mouseup = (e) ->
    $rootScope.edit.mouseup(e)
    
  $scope.undo = ->
    $rootScope.edit.undo()
    
  $scope.redo = ->
    $rootScope.edit.redo()
    
  $scope.updateKern = (letters) ->
    $rootScope.kern.updateKern(letters)
      
    
angular.module('appFilters', ['appCtrl']).filter 'character', ->
  return (character) ->
    return if character.path then character.path else character.character
    
app.directive "vbox", ->
  link: (scope, element, attrs) ->
    attrs.$observe "vbox", (value) ->
      element.attr "viewBox", value