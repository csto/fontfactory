window.app = angular.module('app', ['angular.ujs', 'ngResource', 'drahak.hotkeys', "ui.bootstrap"])

window.app.factory 'Font', ($resource) ->
  $resource(
    "/fonts/:id.json", 
    {id: "@id"},
    {
      get:
        isArray: false
        transformResponse: (data, headersGetter) ->
          data = angular.fromJson(data)
          chars = angular.fromJson(data.characters)
          data.characters = chars
          return data
          
      update: 
        method: "PATCH"
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
  
  $rootScope.char = 1
  $rootScope.fontId = $scope.fontId
  
  $timeout ->
    Font.get(id: $scope.fontId, (font) ->
        $rootScope.font = font
        $rootScope.edit = new Edit()
        $rootScope.kern = new Kern()
      )
  
  $scope.update = ->
    $rootScope.font.$update(
      (u) ->
        $rootScope.font.characters = angular.fromJson(u.characters)
    )
  
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
    
  $scope.updateSize = (kernSize) ->
    $rootScope.kern.updateSize(kernSize)
      
    
angular.module('appFilters', ['appCtrl']).filter 'character', ->
  return (character) ->
    return if character.path then character.path else character.character
    
app.directive "vbox", ->
  link: (scope, element, attrs) ->
    attrs.$observe "vbox", (value) ->
      element.attr "viewBox", value