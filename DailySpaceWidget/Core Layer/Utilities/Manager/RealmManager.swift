//
//  File.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-26.
//

import Foundation
import RealmSwift


protocol RealmManagerProtocol {
  @discardableResult
  static func save<T: Object>(items: [T]) -> Bool
  static func read<T: Object>(ofType: T.Type) -> [T]
}

struct RealmManager: RealmManagerProtocol {
  
  private static let path: String = "db.realm"
  private static let fileURL: URL = {
    FileManager
      .default
      .containerURL(forSecurityApplicationGroupIdentifier: Constant.Config.groupIdentifier)!
      .appendingPathComponent(path)
  } ()
  private static let config = Realm.Configuration(fileURL: fileURL)
  private static var realm: Realm {
    let realm: Realm
    do {
      realm = try Realm(configuration: config)
      return realm
    } catch let error as NSError {
      print("couldn't open realm")
      print(error.localizedDescription)
      fatalError()
    }
  }
  
  @discardableResult
  static func save<T: Object>(items: [T]) -> Bool{
    do {
      try realm.write {
        realm.add(items)
      }
      return true
    } catch let error {
      print("couldn't save to realm")
      print(error.localizedDescription)
      return false
    }
  }
  
  static func read<T: Object>(ofType: T.Type) -> [T] {
    let items = realm.objects(ofType)
    return Array(items.compactMap{$0})
  }

}
