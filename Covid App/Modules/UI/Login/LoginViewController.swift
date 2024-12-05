//
//  LoginViewController.swift
//  Covid App
//
//  Created by Baboon on 05/10/2021.
//  
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passField: UITextField!
    @IBOutlet private weak var showPassButton: UIButton!
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel: LoginViewModel = LoginViewModel()
    
    // MARK: - Superview Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func prepareViewModel() {
        viewModel.loginLoading.subscribe(onNext: {
            [weak self] loading in
            self?.showLoading(loading)
        }).disposed(by: disposeBag)
        viewModel.loginSuccess.subscribe(onNext: {
            [weak self] _ in
            self?.moveToEventList()
        }).disposed(by: disposeBag)
        viewModel.loginFailed.subscribe(onNext: {
            [weak self] error in
            self?.showError(error)
        }).disposed(by: disposeBag)
    }
    private func moveToEventList() {
        let vc = EventsListViewController(nibName: "EventsListViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    private func moveToForgotPass() {
        
    }
}

// MARK: - UI Setup
extension LoginViewController {
    @IBAction private func loginAction() {
        guard let email = emailField.text, let pass = passField.text else { return }
        viewModel.login(email, pass)
    }
    @IBAction private func showPassword() {
        passField.isSecureTextEntry = !passField.isSecureTextEntry
    }
    @IBAction private func forgotPassword() {
        moveToForgotPass()
    }
}
