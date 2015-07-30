import Foundation

@objc protocol StateSerializable
  {
  //WARNING: Always save and load a version of your persistent state object for every object you save into preferences: if your application version is updated and their formats are changed you will need to support alder versions of persistent states!!!
  //Generate a serializable state object
  optional func persistentState()->AnyObject
  //Load state from a serializable state object
  optional func loadPersistentState(state: AnyObject)
  }

