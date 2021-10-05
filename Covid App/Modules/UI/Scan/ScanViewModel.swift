//
//  ScanViewModel.swift
//  Covid App
//
//  Created by Baboon on 05/10/2021.
//  
//

import RxSwift
import RxCocoa

class ScanViewModel {

    var scanLoading = PublishSubject<Bool>()
    var getCovidCertSuccess = PublishSubject<UserCovidCert>()
    var getCovidCertFailed = PublishSubject<Error>()
    var getGuestSuccess = PublishSubject<CheckinData>()
    var getGuestFailed = PublishSubject<Error>()
    
    func getGuestData(_ code: String) {
        
    }
    
    func getCovidCertData(_ code: String) {
        let service = CovidCertService()
        scanLoading.onNext(true)
        service.checkCovidCert(code) { [weak self] result in
            guard let self = self else { return }
            self.scanLoading.onNext(false)
            switch result {
            case .success(let cert):
                self.getCovidCertSuccess.onNext(cert)
            case .failure(let error):
                self.getCovidCertFailed.onNext(error)
            }
        }
    }
}
