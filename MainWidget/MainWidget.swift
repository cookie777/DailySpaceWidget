//
//  MainWidget.swift
//  MainWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-25.
//

import WidgetKit
import SwiftUI
import Intents
import RxSwift

struct Provider: IntentTimelineProvider {
  
  let viewModel = WidgetViewModel(
    photoStorageService: PhotoStorageServiceImplementation(),
    photoFetchService: PhotosFetchServiceImplementation()
  )
  let disposeBag = DisposeBag()
  
  // place holder with no data
  func placeholder(in context: Context) -> PhotoMetadataEntry {
    return PhotoMetadataEntry(
      date: Date(),
      data: PhotoMetadata(copyright: nil, date: nil, explanation: nil, imageHDURL: nil, imageURL: nil, title: nil),
      image: Image(systemName: "heart.fill"),
      configuration: ConfigurationIntent()
    )
  }
  
  // place holder with data
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (PhotoMetadataEntry) -> ()) {
    let entry = PhotoMetadataEntry(
      date: Date(),
      data: PhotoMetadata(copyright: nil, date: nil, explanation: nil, imageHDURL: nil, imageURL: nil, title: nil),
      image: Image(systemName: "heart"),
      configuration: ConfigurationIntent()
    )
    completion(entry)
  }
  
  // when to update and what to display?
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    debugPrint("✅ timeline start")
    
    let midnight = Calendar.current.startOfDay(for: Date())
    let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
//    let current = Date()
//    let next = Calendar.current.date(byAdding: .minute, value: 4, to: current)!
    var entries: [PhotoMetadataEntry] = []
    
    viewModel.getItem()
      .bind { uiImage, metadata in
        debugPrint(uiImage)
        // alternative image
        let image =  uiImage == nil ? Image(systemName: "pencil.tip.crop.circle.badge.plus") : Image(uiImage: uiImage!)
        
        let entry = PhotoMetadataEntry(
          date: Date(),
          data: metadata,
          image: image,
          configuration: configuration
        )
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
      }.disposed(by: disposeBag)
  }
}

// data model
struct PhotoMetadataEntry: TimelineEntry {
  var date: Date
  let data: PhotoMetadata?
  var image: Image
  let configuration: ConfigurationIntent?
}

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
        SmallView(entry: entry)
      case .systemLarge:
        SmallView(entry: entry)
      default:
          Text("Some other WidgetFamily in the future.")
      }
  }
}

struct SmallView: View {
  var entry: Provider.Entry
  var body: some View {
    ZStack {
      Color
        .black
        .ignoresSafeArea()
      
      entry.image
        .resizable()
        .scaledToFill()
      
      VStack {
        Text(DateFormatter.toStringForWidget(date:entry.data?.date) ?? "")
          .foregroundColor(.white)
          .fontWeight(.black)
          .font(.system(size: 12))
          .frame(maxWidth: .infinity, alignment: .leading)
//          .padding()
        
        Divider()
        
        Text(entry.data?.title?.description ?? "")
          .foregroundColor(.white)
          .fontWeight(.black)
          .font(.system(size: 20))
          .frame(maxWidth: .infinity, alignment: .leading)
//          .padding()
        
      }
    }
  }
}



// combine all
@main
struct MainWidget: Widget {
  let kind: String = "MainWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(
      kind: kind,
      intent: ConfigurationIntent.self,
      provider: Provider()
    ) { entry in
      MainWidgetEntryView(entry: entry)
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
    .configurationDisplayName("My Widget")
    .description("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}


// This is only for Xcode debug.
// -> side of preview
struct MainWidget_Previews: PreviewProvider {
  static var previews: some View {
    MainWidgetEntryView(
      entry:  PhotoMetadataEntry(
        date: Date(),
        data: PhotoMetadata(
          copyright: "@Robert Eder",
          date: Date(),
          explanation: "This is exp",
          imageHDURL: nil,
          imageURL: nil,
          title: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        ),
        image: Image(""),
        configuration: nil
      )
    )
    .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
