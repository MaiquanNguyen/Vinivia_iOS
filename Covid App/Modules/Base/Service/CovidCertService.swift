//
//  CovidCertService.swift
//  Covid App
//
//  Created by Baboon on 05/10/2021.
//

import Foundation
import CovidCertificateSDK

class CovidCertService {
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
            var valid: Bool?
            var cert: CovidCertificate?
            var validUnitl: Date?
            var validFrom: Date?
            defer {
                if let valid = valid, let cert = cert, let validUnitl = validUnitl, let validFrom = validFrom {
                    completion(.success(UserCovidCert(valid: valid, cert: cert, until: validUnitl, from: validFrom)))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Can not parse data"])))
                }
            }
            switch result.nationalRules {
            case .success(let rulesData):
                if let until = rulesData.validUntil, let from = rulesData.validFrom {
                    validUnitl = until
                    validFrom = from
                } else {
                    validUnitl = Date()
                    validFrom = Date()
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
            switch result.signature {
            case .success(let data):
                valid = data.isValid
                cert = data.payload
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}
