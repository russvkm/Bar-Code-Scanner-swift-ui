//
//  BarCodeScanner.swift
//  BarCode
//
//  Created by Shashank Pandey on 16/12/23.
//

import SwiftUI

class BarCodeScannerViewModel:ObservableObject{
    @Published var scannedCode:String = ""
    @Published var alertItem:AlertItem?
    
    var notScanned:String{
        scannedCode.isEmpty ? "Not Yet Scanned" : scannedCode
    }
    
    var barScanned:Color{
        scannedCode.isEmpty ? .red : .green
    }
}
