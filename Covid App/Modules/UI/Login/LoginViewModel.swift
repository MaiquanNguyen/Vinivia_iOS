//
//  LoginViewModel.swift
//  Covid App
//
//  Created by Baboon on 05/10/2021.
//  
//

import RxSwift
import RxCocoa

class LoginViewModel {
    
    var loginSuccess = PublishSubject<User?>()
    var loginFailed = PublishSubject<Error>()
    var loginLoading = PublishSubject<Bool>()
    
    func login(_ email: String, _ pass: String) {
        let service = NetworkService()
        loginLoading.onNext(true)
        service.loginUser(email, pass) { [weak self] result in
            guard let self = self else { return }
            self.loginLoading.onNext(false)
            switch result {
            case .success(let response):
                self.saveAccessToken(token: response.data?.accessToken)
                self.loginSuccess.onNext(response.data?.info)
            case .failure(let error):
                self.loginFailed.onNext(error)
            }
        }
    }
    private func saveAccessToken(token: String?) {
        guard let token = token else { return }
        AppConfig.shared.saveAccessToken(token)
    }
}
