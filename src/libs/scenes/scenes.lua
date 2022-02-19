local Scenes = {
    StandardScene = require('src.libs.scenes.standard_scenes.StandardScene'),
    SceneController = require('src.libs.scenes.common.SceneController'),
    SceneView = require('src.libs.scenes.common.SceneView'),
    GameObjectScript = require('src.libs.scenes.common.GameObjectScript'),
    SceneStrategy = require('src.libs.scenes.strategized_scenes.SceneStrategy'),
    StrategizedSceneGO = require('src.libs.scenes.strategized_scenes.StrategizedSceneGO'),
    StrategizedSceneGUI = require('src.libs.scenes.strategized_scenes.StrategizedSceneGUI')
}

return Scenes
