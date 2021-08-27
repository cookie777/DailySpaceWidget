//
//  UserDefaultManager.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-26.
//

import Foundation

protocol UserDefaultManagerProtocol {
  @discardableResult
  static func save<T>(key: String, item: T) -> Bool
  static func read<T>(key: String) -> T?
}

struct UserDefaultManager: UserDefaultManagerProtocol {
  
  static let lastUpdateKey: String = "lastUpdate"
  private static var defaults: UserDefaults? {
    return UserDefaults(suiteName: Constant.Config.groupIdentifier)
  }
  
  @discardableResult
  static func save<T>(key: String, item: T) -> Bool {
    guard let defaults = defaults else { return false }
    defaults.set(item, forKey: key)
    return true
  }
  
  static func read<T>(key: String) -> T? {
    guard let defaults = defaults else { return nil }
    guard let item = defaults.object(forKey: key) as? T else { return nil}
    return item
  }
  
}
