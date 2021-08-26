//
//  MainWidget.swift
//  MainWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-25.
//

import WidgetKit
import SwiftUI
import Intents
import Kingfisher

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> PhotoMetadataEntry {
    
    return PhotoMetadataEntry(date: Date(), data: PhotoMetadata(copyright: nil, date: nil, explanation: nil, imageHDURL: nil, imageURL: nil, title: nil), configuration: ConfigurationIntent())
    
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (PhotoMetadataEntry) -> ()) {
    let entry = PhotoMetadataEntry(date: Date(), data: PhotoMetadata(copyright: nil, date: nil, explanation: nil, imageHDURL: nil, imageURL: nil, title: nil), configuration: ConfigurationIntent())
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    print("bbbb")
    
    let re = PhotosMetadataStorageServiceImplementation()
    print(re.restorePhotoMetadata())
    
    let midnight = Calendar.current.startOfDay(for: Date())
    let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    
    var entries: [PhotoMetadataEntry] = []
    entries.append(PhotoMetadataEntry(date: Date(), data: PhotoMetadata(copyright: nil, date: nil, explanation: nil, imageHDURL: nil, imageURL: nil, title: nil), configuration: configuration))
    
    let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
}

struct PhotoMetadataEntry: TimelineEntry {
  var date: Date
  let data: PhotoMetadata
  let configuration: ConfigurationIntent
}

struct MainWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    Text(entry.date, style: .time)
  }
}

@main
struct MainWidget: Widget {
  let kind: String = "MainWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      MainWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct MainWidget_Previews: PreviewProvider {
  static var previews: some View {
    MainWidgetEntryView(entry:  PhotoMetadataEntry(date: Date(), data: PhotoMetadata(copyright: nil, date: nil, explanation: nil, imageHDURL: nil, imageURL: nil, title: nil), configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
