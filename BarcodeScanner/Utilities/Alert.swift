//
//  Alert.swift
//  BarcodeScanner
//
//  Created by Раджаб Магомедов on 14.03.2025.
//

import SwiftUI


struct AlertItem: Identifiable {
    let id = UUID()
    
    let title: String
    let message: String
    let dismissButton: Alert.Button
}



struct AlertContext {
    
    static let invalidDeviceInput = AlertItem(title: "Invalid Device Input",
                                              message: "Something is wrong with camera. We are unable to capture the input. :(",
                                              dismissButton: .default(Text("OK")))
    static let invalidScannedType = AlertItem(title: "invalid Scanned Type",
                                              message: "The value scanned is not valid. This app scans EAN-8 and EAN-13 barcode types.",
                                              dismissButton: .default(Text("OK")))
}
