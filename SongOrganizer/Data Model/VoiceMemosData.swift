//
//  VoiceMemosData.swift
//  VoiceMemosData
//
//  Created by Jonathan Hyun on 12/6/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

/*
 Create an empty mutable array of VoiceMemo structs using initializer ()
 and store its reference (address of the memory location) into the
 global variable voiceMemoStructList.
 */
var voiceMemoStructList = [VoiceMemo]()

// Global Variable
var audioSession = AVAudioSession()

/*
 Global flag to track changes to albumPhotoStructList.
 If changes are made, albumPhotoStructList will be written to document directory
 in Photo_AlbumApp when the app life cycle state changes.
 */
var dataChanged = false

/*
****************************************
MARK: Get Permission for Voice Recording
****************************************
*/
public func getPermissionForVoiceRecording() {
    
    // Create a shared audio session instance
    audioSession = AVAudioSession.sharedInstance()
    
    //---------------------------
    // Enable Built-In Microphone
    //---------------------------
    
    // Find the built-in microphone.
    guard let availableInputs = audioSession.availableInputs,
          let builtInMicrophone = availableInputs.first(where: { $0.portType == .builtInMic })
    else {
        print("The device must have a built-in microphone.")
        return
    }
    do {
        try audioSession.setPreferredInput(builtInMicrophone)
    } catch {
        print("Unable to Find the Built-In Microphone!")
    }
    
    //--------------------------------------------------
    // Set Audio Session Category and Request Permission
    //--------------------------------------------------
    
    do {
        try audioSession.setCategory(.playAndRecord, mode: .default)
        
        // Activate the audio session
        try audioSession.setActive(true)
        
        // Request permission to record user's voice
        audioSession.requestRecordPermission() { allowed in
            DispatchQueue.main.async {
                if allowed {
                    // Permission is recorded in the Settings app on user's device
                } else {
                    // Permission is recorded in the Settings app on user's device
                }
            }
        }
    } catch {
        print("Setting category or getting permission failed!")
    }
}

/*
 *******************************************************
 MARK: Write Voice Memos Data File to Document Directory
 *******************************************************
 */
public func writeVoiceMemosDataFile() {
 
    // Obtain URL of the JSON file into which data will be written
    let urlOfJsonFileInDocumentDirectory: URL = documentDirectory.appendingPathComponent("VoiceMemosData.json")
 
    // Encode voiceMemoStructList into JSON and write it into the JSON file
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(voiceMemoStructList) {
        do {
            try encoded.write(to: urlOfJsonFileInDocumentDirectory)
        } catch {
            print("Unable to write encoded voice memos data to document directory!")
        }
    } else {
        print("Unable to encode voice memos data!")
    }
    
    // Set global flag defined above on top
    dataChanged = false
}
