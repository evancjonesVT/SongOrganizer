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
 ********************************
 MARK: Read Voice Memos Data File
 ********************************
 */
public func readVoiceMemosDataFile() {
    
    var fileExistsInDocumentDirectory = false
   
    let voiceMemosDataFullFilename = "VoiceMemosData.json"
   
    // Obtain URL of the VoiceMemosData file in document directory on user's device
    // Global constant documentDirectory is defined in UtilityFunctions.swift
    let urlOfJsonFileInDocumentDirectory = documentDirectory.appendingPathComponent(voiceMemosDataFullFilename)
 
    do {
        /*
         Try to get the contents of the file. The left hand side is
         suppressed by using '_' since we do not use it at this time.
         Our purpose is just to check to see if the file is there or not.
         */
        
        _ = try Data(contentsOf: urlOfJsonFileInDocumentDirectory)
        
        /*
         If 'try' is successful, it means that the VoiceMemosData.json
         file exists in document directory on the user's device.
         ---
         If 'try' is unsuccessful, it throws an exception and
         executes the code under 'catch' below.
         */
       
        // VoiceMemosData file exists in the document directory
        
        fileExistsInDocumentDirectory = true
        
        /*
         --------------------------------------------------
         |   The app is being launched after first time   |
         --------------------------------------------------
         The VoiceMemosData.json file exists in document directory on the user's device.
         Load it from Document Directory into voiceMemoStructList.
         */

            // The function is given in UtilityFunctions.swift
            voiceMemoStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: voiceMemosDataFullFilename, fileLocation: "Document Directory")
            print("VoiceMemosData is loaded from document directory")
        
        
       
    } catch {
        /*
         ----------------------------------------------------
         |   The app is being launched for the first time   |
         ----------------------------------------------------
         The VoiceMemosData.json file does not exist in document directory on the user's device.
         Load it from main bundle (project folder) into voiceMemoStructList.
         
         This catch section will be executed only once when the app is launched for the first time
         since we write and read the file in document directory on the user's device after first use.
         */
       
            // The function is given in UtilityFunctions.swift
            voiceMemoStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: voiceMemosDataFullFilename, fileLocation: "Main Bundle")
            print("VoiceMemosData is loaded from main bundle")
    }
    
    if !fileExistsInDocumentDirectory {
        for voiceMemo in voiceMemoStructList {
            /*
             ==============================================================
             |   Copy Audio Files from Main Bundle to Document Directory  |
             ==============================================================
             */
            // Example audioFullFilename = "BDB2D176-D39C-4F22-976E-F525F15C0936.m4a"
            let array = voiceMemo.audioFullFilename.components(separatedBy: ".")
            
            // array[0] = "BDB2D176-D39C-4F22-976E-F525F15C0936"
            // array[1] = "m4a"
            
            // Copy each voice memo audio file from main bundle to document directory
            // The function is given in UtilityFunctions.swift
            copyFileFromMainBundleToDocumentDirectory(filename: array[0], fileExtension: array[1])
        }
    }
}

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
