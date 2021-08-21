//
//  Date+currentDay.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-17.
//

import Foundation

extension Date {
  
  static func getPastDate(days: Int = 0) -> String {
    
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    
    if let pastDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) {
      return df.string(from:  pastDate)
    } else {
      return df.string(from: Date())
    }
    
  }
  
}
