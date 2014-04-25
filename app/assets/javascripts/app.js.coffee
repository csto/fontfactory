window.app = angular.module('app', ['drahak.hotkeys'])

window.app.controller 'tabCtrl', ($scope) ->
  $scope.tab = 'editor'
  
  $scope.setTab = (tab) ->
    $scope.tab = tab

window.app.controller 'appCtrl', ($scope, $rootScope, $timeout, Edit) ->
  $timeout ->
    $rootScope.edit = new Edit(1)
  
  $rootScope.characters = window.characters
  $rootScope.char = 1
  
  $scope.setChar = (c) ->
    Snap.selectAll('#editor *').remove()
    $rootScope.edit = new Edit(c)
  
  $scope.setTool = (tool) ->
    $rootScope.edit.setTool(tool)
    
  $scope.setZoom = (z) ->
    # newZoom = $rootScope.zoom * z
    $rootScope.edit.paperZoom(z)
    
  $scope.mousedown = (e) ->
    $rootScope.edit.mousedown(e)
    
  $scope.mousemove = (e) ->
    $rootScope.edit.mousemove(e)
    
  $scope.mouseup = (e) ->
    $rootScope.edit.mouseup(e)
      
    
angular.module('appFilters', ['appCtrl']).filter 'character', ->
  return (character) ->
    return if character.path then character.path else character.character
    
app.directive "vbox", ->
  link: (scope, element, attrs) ->
    attrs.$observe "vbox", (value) ->
      element.attr "viewBox", value