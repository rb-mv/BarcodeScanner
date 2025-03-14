//
//  BarcodeScannerViewModel.swift
//  BarcodeScanner
//
//  Created by Раджаб Магомедов on 14.03.2025.
//

import SwiftUI

final class BarcodeScannerViewModel: ObservableObject { //Все view model должны быть ObservableObject Потому что мы вставляем их в другой view. А там где мы вставляем наш BarcodeScannerViewModel оно будет StateObject
    
    @Published var scannedCode = ""
    @Published var alertItem: AlertItem?
    
    
    var statusText: String {
        scannedCode.isEmpty ? "Not yet scanned" : scannedCode
    }
    
    var statusTextColor: Color {
        scannedCode.isEmpty ? .red : .green
    }
    
}

