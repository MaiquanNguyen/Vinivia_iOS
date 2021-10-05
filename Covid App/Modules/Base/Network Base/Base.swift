//
//  Base.swift
//  Covid App
//
//  Created by Baboon on 04/10/2021.
//

import Foundation

protocol BaseHeaders {
    var commonHeaders: [String: String] { get }
    var loggedHeader: [String: String] { get }
}

extension BaseHeaders {
    var commonHeaders: [String: String] {
        let headersParameters: [String: String] = ["Content-type": "application/json"]
        return headersParameters
    }
    
    var loggedHeader: [String: String] {
        var headersParameters: [String: String] = ["Content-type": "application/json"]
        if let accessToken = AppConfig.shared.getAccessToken() {
            headersParameters["Authorization"] = "Bearer \(accessToken)"
        }
        return headersParameters
    }
}

public struct CommonResponse<T: Codable>: Codable {
    public var code: Int?
    public var data: T?
    public var message: String?
}

public struct BaseError: Error, LocalizedError, Codable {
    var code: Int = 0
    var message: String = ""
    public var localizedDescription: String {
        message
    }
    public var errorDescription: String? {
        message
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
