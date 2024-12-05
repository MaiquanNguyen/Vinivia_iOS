//
//  NetworkServiceHelper.swift
//  Covid App
//
//  Created by Baboon on 04/10/2021.
//

import Moya

//MARK: - Switch live to testing and the otherwise
enum NetworkServiceType {
    case live
    case test
}

class NetworkServiceHelper<T:TargetType> {
    // MARK:- Properties
    var provider: MoyaProvider<T>!
    // MARK:- Init
    init(_ type: NetworkServiceType = .live) {
        let serviceType = type == .live ? MoyaProvider<T>.neverStub : MoyaProvider<T>.immediatelyStub
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        provider = MoyaProvider<T>(stubClosure: serviceType, plugins: [networkLogger])
    }
    
    func request<R: Codable>(target: T, completion: @escaping (Result<CommonResponse<R>, Error>) -> Void) {
        print("Network Call: \(T.self)")

        provider.request(target) { result in
            switch result
            {
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(CommonResponse<R>.self, from: value.data)
                    
                    if let code = response.code, code >= 400 {
                        let err = BaseError(code: code, message: response.message ?? "")
                        print("Reponse Failure \(err)")
                        completion(.failure(err))
                    } else {
                        completion(.success(response))
                    }
                }
                catch let error {
                    print("Decode Failure \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request Failure \(error)")
                completion(.failure(error))
            }
        }
    }
}
