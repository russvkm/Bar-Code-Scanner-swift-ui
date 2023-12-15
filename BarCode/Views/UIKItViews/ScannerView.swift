//
//  ScannerView.swift
//  BarCode
//
//  Created by Shashank Pandey on 15/12/23.
//

import SwiftUI

struct ScannerView:UIViewControllerRepresentable {
    @Binding var scannerCode:String
    @Binding var alertItem:AlertItem?
    func makeUIViewController(context: Context) -> BarCodeVC {
        BarCodeVC(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: BarCodeVC, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
    
    class Coordinator:NSObject, ScannerVCDelegate{
        let scannerView:ScannerView
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        func didFind(barcode: String) {
            DispatchQueue.main.async{ [weak self] in
                self?.scannerView.scannerCode = barcode
            }
            
        }
        
        func surfaceError(error: CameraError) {
            DispatchQueue.main.async{ [weak self] in
                switch error{
                case .barCodeError:
                    self?.scannerView.alertItem = AlertType.invalidBarCode
                case .cameraError:
                    self?.scannerView.alertItem = AlertType.invalidAlertInput
                    
                }
            }
            
        }
        
        
    }
    
    
}
