//
//  CovidAPI.swift
//  Covid App
//
//  Created by Baboon on 04/10/2021.
//

import Moya

enum CovidAPI {
    case login(_ email: String, _ password: String)
    case getCheckinData(_ user: Int,_ event: Int)
    case getEvent
    case searchEvent(_ query: String)
    case updateCheckinStatus(_ user: Int,_ event: Int)
}

extension CovidAPI: TargetType, BaseHeaders {
    var baseURL: URL {
        guard let url = URL(string: Constants.BaseUrl) else { fatalError("stringURL could not be configured") }
        return url
    }
    
    var path: String {
        switch self {
        case .login(_, _):
            return "/v2/checkInSystem/auth/login"
        case .getCheckinData(let user, let event):
            return "/v2/checkInSystem/check-in/\(user)/event/\(event)"
        case .getEvent:
            return "/v2/checkInSystem/events"
        case .searchEvent(_):
            return "/v2/checkInSystem/events"
        case .updateCheckinStatus(let user, let event):
            return "/v2/checkInSystem/check-in/\(user)/event/\(event)"
        }
    }
    
    var method: Method {
        switch self {
        case .login(_, _):
            return .post
        case .getCheckinData(_, _):
            return .get
        case .getEvent:
            return .get
        case .searchEvent(_):
            return .get
        case .updateCheckinStatus(_, _):
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .login(let email, let pass):
            let params : [String: Any] = ["email": email, "password": pass]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .getCheckinData(_, _):
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getEvent:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .searchEvent(_):
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .updateCheckinStatus(_, _):
            return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login(_, _):
            return commonHeaders
        default:
            return loggedHeader
        }
    }
    
    
}
