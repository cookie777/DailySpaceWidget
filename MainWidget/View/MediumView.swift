//
//  Medium.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-31.
//

import WidgetKit
import SwiftUI

struct MediumView: View {
  var entry: Provider.Entry
  var body: some View {
    
    ZStack {
      Color
        .black
      
      VStack(
        alignment: .leading,
        spacing: 8
      ) {
        Text(Formatter.dateToStringForWidget(date:entry.data?.date) ?? "")
          .foregroundColor(.white)
          .fontWeight(.black)
          .font(.system(size: 12))
          .opacity(0.8)
          .shadow(color: .black, radius: 2, x: 2, y: 2)
        
        Text(entry.data?.title?.description ?? "")
          .foregroundColor(.white)
          .fontWeight(.black)
          .font(.system(size: 14))
          .opacity(0.8)
          .shadow(color: .black, radius: 2, x: 2, y: 2)
      }
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity,
        alignment: .bottomLeading
      )
      .padding()
      .background(
        entry.image
          .resizable()
          .scaledToFill()
      )
      
    }
  }
}


struct MediumView_Previews: PreviewProvider {
  static var previews: some View {
    MainWidgetEntryView.mock
      .previewContext(WidgetPreviewContext(family: .systemMedium))
  }
}
