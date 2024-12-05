//
//  BaseViewController.swift
//  Covid App
//
//  Created by Baboon on 05/10/2021.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addTapToHideTooltip()
        // Do any additional setup after loading the view.
    }
    
    func addTapToHideTooltip() {
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideTooltip))
        hideKeyboardGesture.cancelsTouchesInView = false
        if self.view.gestureRecognizers == nil {
            self.view.isUserInteractionEnabled = true
            self.view.addGestureRecognizer(hideKeyboardGesture)
        }
    }
    @objc func hideTooltip() {
        self.view.endEditing(true)
    }

}
