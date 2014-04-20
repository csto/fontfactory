app = angular.module('app', [])

app.controller 'appCtrl', ($scope) ->
  $scope.characters = window.characters
  
  $scope.setTool = (tool) ->
    $scope.tool = tool
    
angular.module('appFilters', ['appCtrl']).filter 'character', ->
  return (character) ->
    return if character.path then character.path else character.character