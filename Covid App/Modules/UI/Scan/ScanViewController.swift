//
//  ScanViewController.swift
//  Covid App
//
//  Created by Baboon on 05/10/2021.
//  
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

enum ScanType {
    case certificate
    case guest
}

class ScanViewController: UIViewController {
    
    @IBOutlet weak var captureView: UIView!
    var scanType: ScanType = .guest
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
    // MARK: - Superview Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUI()
        addScanning()
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel = ScanViewModel()
    
    func prepareViewModel() {
        viewModel.scanLoading.subscribe(onNext: {
            [weak self] loading in
            self?.showLoading(loading)
        }).disposed(by: disposeBag)
        viewModel.getCovidCertSuccess.subscribe(onNext: {
            [weak self] cert in
            self?.showCertInfo(cert)
        }).disposed(by: disposeBag)
        viewModel.getCovidCertFailed.subscribe(onNext: {
            [weak self] error in
            self?.showError(error)
        }).disposed(by: disposeBag)
    }
    
    private func showCertInfo(_ cert: UserCovidCert) {
        print("show cert")
    }
}

// MARK: - Binding
extension ScanViewController {
    //TO-DO: Bind UI Elements
}

// MARK: - UI Setup
extension ScanViewController {
    private func renderUI() {
        var backTitle = ""
        switch scanType {
        case .guest:
            backTitle = "Scan QR  Code To Check Covid Cert"
        case .certificate:
            backTitle = "Back To Event List"
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_ic"), title: backTitle, target: self, action: #selector(backHandle))
    }
    
    @objc private func backHandle() {
        navigationController?.popViewController(animated: true)
    }
    
    private func addScanning() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = supportedCodeTypes
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = captureView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        captureView.layer.addSublayer(previewLayer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.captureSession.startRunning()
        }
        
    }
    
    private func found(code: String) {
        print(code)
        switch scanType {
        case .certificate:
            viewModel.getCovidCertData(code)
        case .guest:
            viewModel.getGuestData(code)
        }
    }
    
    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device need to rest, buy a new one.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
}

extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            captureSession.stopRunning()

            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)
            }
        }
}
