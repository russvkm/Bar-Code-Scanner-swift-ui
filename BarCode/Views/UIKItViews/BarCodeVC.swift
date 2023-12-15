//
//  BarCodeVC.swift
//  BarCode
//
//  Created by Shashank Pandey on 15/12/23.
//

import UIKit
import AVFoundation

enum CameraError{
    case cameraError
    case barCodeError
}

protocol ScannerVCDelegate: AnyObject{
    func didFind(barcode:String)
    func surfaceError(error:CameraError)
}

class BarCodeVC:UIViewController{
    var captureSession = AVCaptureSession()
    var previewLayer:AVCaptureVideoPreviewLayer?
    weak var scannerDelegate:ScannerVCDelegate?
    
    init(scannerDelegate:ScannerVCDelegate){
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCamera()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let previewLayer = previewLayer else {
            scannerDelegate?.surfaceError(error: .cameraError)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setUpCamera(){
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.surfaceError(error: .cameraError)
            return
        }
        var videoInput:AVCaptureDeviceInput
        do{
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch {
            scannerDelegate?.surfaceError(error: .cameraError)
            return
        }
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }else {
            scannerDelegate?.surfaceError(error: .cameraError)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metaDataOutput){
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13, .qr]
        } else {
            scannerDelegate?.surfaceError(error: .cameraError)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        DispatchQueue.global(qos: .default).async{ [weak self] in
            self?.captureSession.startRunning()
        }
        
    }
    
}

extension BarCodeVC:AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            scannerDelegate?.surfaceError(error: .barCodeError)
            return
        }
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.surfaceError(error: .barCodeError)
            return
        }
        guard let barCode = machineReadableObject.stringValue else {
            scannerDelegate?.surfaceError(error: .barCodeError)
            return
        }
        scannerDelegate?.didFind(barcode: barCode)
    }
}
