//
//  ScannerVC.swift
//  BarcodeScanner
//
//  Created by Раджаб Магомедов on 13.03.2025.
//

import UIKit
import AVFoundation


enum CameraError {
    case invalidDeviceInput
    case invalidScannedValue
}


protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode: String) //Протокол для общения UIKit (UIKit передает функцию didFind в Coordinator, а он в свою очередь в SwiftUI
    func didSurface(error: CameraError)
}


final class ScannerVC: UIViewController {
    let captureSession = AVCaptureSession() // Захват того, что изображено на камере
    var previewLayer: AVCaptureVideoPreviewLayer? // та вещь которая отражает вид камеры в опредлённом месте на экране
    weak var scannerDelegate: ScannerVCDelegate!
    
    init(scannerDelegate: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    
    
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        } //Чтобы убедиться что у нас есть девайс с которого будет происходит сбор данных
        
        
        let videoInput: AVCaptureDeviceInput
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        } else {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill // ForceUnwrap потому что в предудущей строке мы его задаем
        
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
        
    }
    
}


extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            scannerDelegate.didSurface(error: .invalidScannedValue)
            return
        }
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate.didSurface(error: .invalidScannedValue)
            return
        }
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate.didSurface(error: .invalidScannedValue)
            return
        }
        
        //captureSession.stopRunning()
        scannerDelegate.didFind(barcode: barcode)
        
    }
}
