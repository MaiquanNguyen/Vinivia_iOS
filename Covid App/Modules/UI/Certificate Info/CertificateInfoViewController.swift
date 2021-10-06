//
//  CertificateInfoViewController.swift
//  Covid App
//
//  Created by Baboon on 06/10/2021.
//  
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI
import CovidCertificateSDK

class CertificateInfoViewController: UIViewController {
    
    @IBOutlet private weak var certPhoto: UIImageView!
    @IBOutlet private weak var userName: UILabel!
    @IBOutlet private weak var userDOB: UILabel!
    @IBOutlet private weak var issueDate: UILabel!
    @IBOutlet private weak var expiration: UILabel!
    @IBOutlet private weak var validLabel: UILabel!
    
    @IBOutlet private weak var nameView: UIView!
    @IBOutlet private weak var dobView: UIView!
    @IBOutlet private weak var issueDateView: UIView!
    @IBOutlet private weak var expirationView: UIView!
    
    var certInfo: UserCovidCert?
    
    // MARK: - Superview Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel: CertificateInfoViewModel!
}

// MARK: - Binding
extension CertificateInfoViewController {
   
    @IBAction private func gotoCheckin() {
        
    }
    @IBAction private func backToScan() {
        
    }
}

// MARK: - UI Setup
extension CertificateInfoViewController {
    func setupUI() {
        if let cert = certInfo {
            if cert.isValid {
                validLabel.text = "Yes"
                validLabel.textColor = UIColor(hexString: "#28C76F")
            } else {
                validLabel.text = "No"
                validLabel.textColor = UIColor(hexString: "#EA4335")
            }
            userDOB.text = cert.certificate.dateOfBirthFormatted
            let person = cert.certificate.person
            userName.text = "\(person.givenName ?? "") \(person.familyName ?? "")"
            expiration.text = getStringFromDate(cert.validUntil)
            issueDate.text = getStringFromDate(cert.validFrom)
        } else {
            nameView.isHidden = true
            dobView.isHidden = true
            issueDateView.isHidden = true
            expirationView.isHidden = true
        }
    }
    
    private func getStringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
