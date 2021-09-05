//
//  MainWidgetEntryView.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-31.
//

import SwiftUI
import WidgetKit

// how to display with data
struct MainWidgetEntryView : View {
  var entry: Provider.Entry
  @Environment(\.widgetFamily) var family
  @ViewBuilder
  var body: some View {
    switch family {
      case .systemSmall:
        SmallView(entry: entry)
      case .systemMedium:
        MediumView(entry: entry)
      case .systemLarge:
        LargeView(entry: entry)
      default:
        Text("Some other WidgetFamily in the future.")
    }
  }
}

extension MainWidgetEntryView {
  static let mock = MainWidgetEntryView(
    entry:  PhotoMetadataEntry.mock
  )
}


struct MainWidgetEntryView_Previews: PreviewProvider {
  static var previews: some View {
    MainWidgetEntryView.mock
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
