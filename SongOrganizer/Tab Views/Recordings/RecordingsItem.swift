//
//  RecordingsItem.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/18/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct RecordingsItem: View {
    // Input Parameter passed by value
    let voiceMemo: VoiceMemo
    
    var body: some View {
        HStack {
            Image(voiceMemo.category)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
           
            VStack(alignment: .leading) {
                Text(voiceMemo.title)
                    .foregroundColor(.blue)
                HStack {
                    Text("Category: ")
                    Text(voiceMemo.category)
                }
                HStack {
                    Text("Created: ")
                    Text(voiceMemo.dateTime)
                }
                HStack {
                    Text("Duration: ")
                    Text(voiceMemo.duration)
                }
            }
            .font(.system(size: 14))
           
        }   // End of HStack
    }
}

struct RecordingsItem_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsItem(voiceMemo: voiceMemoStructList[0])
    }
}
