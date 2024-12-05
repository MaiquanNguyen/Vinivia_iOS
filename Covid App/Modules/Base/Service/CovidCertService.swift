//
//  CovidCertService.swift
//  Covid App
//
//  Created by Baboon on 05/10/2021.
//

import Foundation
import CovidCertificateSDK
import RxSwift

class CovidCertService {
    
    private var disposeBag = DisposeBag()
    
    func checkCovidCert(_ code: String, completion: @escaping (Result<UserCovidCert, Error>) -> Void) {
        let result: Result<VerifierCertificateHolder, CovidCertError> = CovidCertificateSDK.Verifier.decode(encodedData: code)
        switch result {
        case .success(let holder):
            self.checkCertHolder(holder, completion: completion)
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func checkCertHolder(_ holder: VerifierCertificateHolder, completion: @escaping (Result<UserCovidCert, Error>) -> Void) {
        CovidCertificateSDK.Verifier.check(holder: holder, forceUpdate: false) { result in
            let getResult: PublishSubject<VerificationResult?> = PublishSubject()
            let getSignature: PublishSubject<ValidationResult?> = PublishSubject()
            let getError: PublishSubject<Error> = PublishSubject()
            getError.subscribe(onNext: {
                error in
                print("Error \(error) \(error.localizedDescription)")
                completion(.failure(error))
            }).disposed(by: self.disposeBag)
            Observable.zip(getResult, getSignature, resultSelector: { verification, signature in
                if let verification = verification, let signature = signature, let from = verification.validFrom, let to = verification.validUntil {
                    let userCert = UserCovidCert(valid: signature.isValid, certificate: signature.payload, from: from, unitl: to)
                    completion(.success(userCert))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Can not get covid certificate data"])))
                }
            }).observeOn(MainScheduler.instance).subscribe().disposed(by: self.disposeBag)

            switch result.signature {
            case .success(let rulesData):
                getSignature.onNext(rulesData)
            case .failure(_):
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "The COVID certificate does not have a valid signature"])))
            }
            switch result.nationalRules {
            case .success(let rules):
                getResult.onNext(rules)
            case .failure(let error):
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "The COVID certificate does not have a valid national rules"])))
            }
        }
    }
}
