//
//  LyricsAPI.swift
//  LyricsAPI
//
//  Created by Jonathan Hyun on 11/30/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import Foundation
import SwiftUI

// Global variables
var lyric = ""

/*
 =================================
 MARK: Obtain Lyrics Data from API
 =================================
 */
public func getLyrics(query1: String, query2: String) {
    
    // Filter spaces with %20.
    let searchQuery1 = query1.replacingOccurrences(of: " ", with: "%20")
    let searchQuery2 = query2.replacingOccurrences(of: " ", with: "%20")
    
    let searchURL = "https://api.lyrics.ovh/v1/\(searchQuery1)/\(searchQuery2)"
    
    let getLyricsJsonData = getJsonDataFromApi(apiUrl: searchURL)
    
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: getLyricsJsonData!,
            options: JSONSerialization.ReadingOptions.mutableContainers)
        
        //print(jsonResponse)
        if let lyricsObject = jsonResponse as? [String: Any] {
            //print(lyricsObject)
            if let theLyrics = lyricsObject["lyrics"] as? String {
                lyric = theLyrics
                print(lyric)
            }
        }
        
    } catch {
        return
    }
}
