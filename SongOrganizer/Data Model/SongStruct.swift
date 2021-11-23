//
//  SongStruct.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/23/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct Song: Decodable {
    
    var title: String
    var album: String
    var artist: String
    var releaseYear: Int16
    var length: String
    var appleMusic: String
    var spotify: String
    var youtube: String
    var photo: String
}
