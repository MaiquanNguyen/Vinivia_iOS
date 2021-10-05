//
//  NetworkService.swift
//  Covid App
//
//  Created by Baboon on 05/10/2021.
//

import Foundation
import Moya

class NetworkService: NetworkServiceHelper<CovidAPI> {
    func loginUser(_ email: String, _ password: String, completion: @escaping (Result<CommonResponse<LoginResponse>, Error>) -> Void) {
        request(target: .login(email, password), completion: completion)
    }
    func getCheckinData(_ userId: Int, _ eventId: Int, completion: @escaping (Result<CommonResponse<CheckinData>, Error>) -> Void) {
        request(target: .getCheckinData(userId, eventId), completion: completion)
    }
    func getEvent(completion: @escaping (Result<CommonResponse<[Event]>, Error>) -> Void) {
        request(target: .getEvent, completion: completion)
    }
    func updateCheckinStatus(_ userId: Int, _ eventId: Int, completion: @escaping (Result<CommonResponse<CheckinData>, Error>) -> Void) {
        
    }
}
