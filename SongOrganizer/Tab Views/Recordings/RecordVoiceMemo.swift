//
//  RecordVoiceMemo.swift
//  RecordVoiceMemo
//
//  Created by Jonathan Hyun on 12/6/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI
import AVFoundation

/*
 Difference between fileprivate and private:
 fileprivate --> makes the constant or variable accessible anywhere only inside this source file.
 private     --> makes it accessible only inside the type (e.g., class, struct) that declared it.
 */
fileprivate var audioFullFilename = ""
fileprivate var audioRecorder: AVAudioRecorder!

struct RecordVoiceMemo: View {

    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
    
    /*
     Display this view as a Modal View and enable it to dismiss itself
     to go back to the previous view in the navigation hierarchy.
     */
    @Environment(\.presentationMode) var presentationMode
    
    let voiceMemoCategories = ["Music", "Other"]
    @State private var selectedIndex = 0    // Music
    
    @State private var recordingVoice = false
    @State private var voiceMemoTitle = ""

    // Alerts
    @State private var showMissingInputDataAlert = false
    @State private var showVoiceMemoAddedAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Audio Recording Title")) {
                HStack {
                    TextField("Enter audio recording title", text: $voiceMemoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.words)

                    // Button to clear the text field
                    Button(action: {
                        voiceMemoTitle = ""
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                    .alert(isPresented: $showMissingInputDataAlert, content: { missingInputDataAlert })
                    /*
                     ----------------------------------------------------------------
                     Modifying the same view with more than one .alert does not work!
                     You should modify a different view for each .alert to work.
                     Therefore, showMissingInputDataAlert is attached to the Button
                     above and showVoiceMemoAddedAlert is attached to the Form below.
                     ----------------------------------------------------------------
                     */

                }   // End of HStack
            }
            Section(header: Text("Select Audio Recording Category")) {
                Picker("", selection: $selectedIndex) {
                    ForEach(0 ..< voiceMemoCategories.count, id: \.self) {
                        Text(voiceMemoCategories[$0])
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
        }//form end
            Section(header: Text("Audio Duration Time")) {
                Text(userData.voiceRecordingDuration)
            }
            Section(header: Text("Audio Recording")) {
                Button(action: {
                    voiceRecordingMicrophoneTapped()
                }) {
                    voiceRecordingMicrophoneLabel
                }
            }
            .font(.system(size: 14))
            .alert(isPresented: $showVoiceMemoAddedAlert, content: { voiceMemoAddedAlert })
            .navigationBarTitle(Text("Record New Audio Recording"), displayMode: .inline)
            // Place the Add (+) button on right of the navigation bar
            .navigationBarItems(trailing:
                Button(action: {
                    if inputDataValidated() {
                        addNewVoiceMemo()
                        showVoiceMemoAddedAlert = true
                    } else {
                        showMissingInputDataAlert = true
                    }
                }) {
                    Image(systemName: "plus")
            })
    } // end of Body.
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        if voiceMemoTitle.isEmpty || audioFullFilename.isEmpty {
            return false
        }
        
        return true
    }
    
    /*
     ------------------------------
     MARK: Missing Input Data Alert
     ------------------------------
     */
    var missingInputDataAlert: Alert {
        Alert(title: Text("Missing Title and / or Recording!"),
              message: Text("Please enter a title and record your new audio recording!"),
              dismissButton: .default(Text("OK")) )
        /*
        Tapping OK resets @State var showMissingInputDataAlert to false.
        */
    }
    
    /*
     --------------------------------
     MARK: New Voice Memo Added Alert
     --------------------------------
     */
    var voiceMemoAddedAlert: Alert {
        Alert(title: Text("New Audio Recording Added!"),
              message: Text("New audio recording is added to your recordings list."),
              dismissButton: .default(Text("OK")) {
                
                // Dismiss this Modal View and go back to the previous view in the navigation hierarchy
                presentationMode.wrappedValue.dismiss()
              })
    }

    /*
     ----------------------------------------
     MARK: - Voice Recording Microphone Label
     ----------------------------------------
     */
    var voiceRecordingMicrophoneLabel: some View {
        VStack {
            Image(systemName: recordingVoice ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
                .padding()
            Text(recordingVoice ? "Recording your voice... Tap to Stop!" : "Start Recording!")
                .multilineTextAlignment(.center)
        }
    }
    
    /*
     ---------------------------------------
     MARK: Voice Recording Microphone Tapped
     ---------------------------------------
     */
    func voiceRecordingMicrophoneTapped() {
        if audioRecorder == nil {
            recordingVoice = true
            userData.startDurationTimer()
            startRecording()
        } else {
            recordingVoice = false
            userData.stopDurationTimer()
            finishRecording()
        }
    }
    
    /*
     --------------------------------
     MARK: Start Voice Memo Recording
     --------------------------------
     */
    func startRecording() {

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioFullFilename = UUID().uuidString + ".m4a"
        let audioFilenameUrl = documentDirectory.appendingPathComponent(audioFullFilename)
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilenameUrl, settings: settings)
            audioRecorder.record()
        } catch {
            finishRecording()
        }
    }
    
    /*
     ---------------------------------
     MARK: Finish Voice Memo Recording
     ---------------------------------
     */
    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        recordingVoice = false
    }
    
    /*
     ------------------------
     MARK: Add New Voice Memo
     ------------------------
     */
    func addNewVoiceMemo() {
        
        // Instantiate a Date object
        let date = Date()
        
        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()
        
        // Set the date format to yyyy-MM-dd at HH:mm:ss
        dateFormatter.dateFormat = "yyyy-MM-dd' at 'HH:mm:ss"
        
        // Format the Date object as above and convert it to String
        let currentDateTime = dateFormatter.string(from: date)
        
        // Create a new instance of VoiceMemo struct and dress it up
        let newVoiceMemo = VoiceMemo(id: UUID(), title: voiceMemoTitle, audioFullFilename: audioFullFilename, category: voiceMemoCategories[selectedIndex], duration: userData.voiceRecordingDuration, dateTime: currentDateTime)
        
        // Append the new voice memo to the list
        userData.voiceMemosList.append(newVoiceMemo)
        
        // Set the global variable point to the changed list
        voiceMemoStructList = userData.voiceMemosList
        
        // Set global flag defined in VoiceMemosData
        dataChanged = true
        
        // Initialize audioFullFilename for the next use.
        // audioFullFilename = "" if the user did not record his/her voice.
        
        audioFullFilename = ""
        
        // Initialize voiceRecordingDuration
        userData.voiceRecordingDuration = ""
        
        // Dismiss this View and go back
        presentationMode.wrappedValue.dismiss()
    }
}
