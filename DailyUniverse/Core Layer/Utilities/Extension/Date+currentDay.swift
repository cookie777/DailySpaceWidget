//
//  Date+currentDay.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-17.
//

import Foundation

extension Date {
  
  static func getPastDate(days: Int = 0) -> String {
    if let pastDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) {
      return DateFormatter.toStringForAPI(date: pastDate)!
    } else {
      return DateFormatter.toStringForAPI(date: Date())!
    }
  }
  
}


