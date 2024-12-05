//
//  GuestInfoViewController.swift
//  Covid App
//
//  Created by Baboon on 06/10/2021.
//  
//

import UIKit
import RxSwift
import RxCocoa

class GuestInfoViewController: UIViewController {
    
    // MARK: - Superview Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel: GuestInfoViewModel!
}

// MARK: - Binding
extension GuestInfoViewController {
    //TO-DO: Bind UI Elements
}

// MARK: - UI Setup
extension GuestInfoViewController {
    func setupUI() {
        
    }
}
