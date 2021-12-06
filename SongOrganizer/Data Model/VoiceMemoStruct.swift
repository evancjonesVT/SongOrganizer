//
//  VoiceMemoStruct.swift
//  VoiceMemoStruct
//
//  Created by Jonathan Hyun on 12/6/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI
 
struct VoiceMemo: Hashable, Codable, Identifiable {

    var id: UUID                    // UUID of the voice memo
    var title: String               // Title of the voice memo
    var audioFullFilename: String   // Recorded voice full filename = filename + fileExtension (.m4a)
    var category: String            // Category of voice memo
    var duration: String            // Duration of the voice memo as hh:mm:ss.ms
    var dateTime: String            // Date and time when voice memo was created
}

/*
 {
     "id": "3F6B4F50-FA25-4EB1-9F27-64FD71950B32",
     "title": "A Voice Memo for the Family",
     "audioFullFilename": "7586915E-5BF5-4299-ACA3-7BBC164D8000.m4a",
     "category": "Family",
     "duration": "00:00:04.23",
     "dateTime": "2020-01-12 at 14:11:54"
 }
 */

