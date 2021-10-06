//
//  BaseModel.swift
//  Covid App
//
//  Created by Baboon on 04/10/2021.
//

import Foundation
import CovidCertificateSDK

struct Event: Codable {
    var id: Int?
    var name: String?
    var logo: String?
    var timezone, startDate, endDate: String?
    var organizationId: Int?
    var eventFormat, status, locationType: String?
    var address: String?
    var eventTypeId, totalSales: Int?
    var currency: String?
    var currencyId, totalTicketSold, timeToOpen: Int?
    var createdBy, updatedBy: String?
    var themeId: Int?
    var eventDescription, hubOverview, preEventAccessStart: String?
    var isAllowJoinEventEnded: Bool?
    var numberOfDays: Int?
    var createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, logo, timezone, startDate, endDate
        case organizationId, eventFormat, status, locationType, address
        case eventTypeId, totalSales, currency, currencyId, totalTicketSold, timeToOpen
        case createdBy, updatedBy, themeId, eventDescription, hubOverview, preEventAccessStart
        case numberOfDays, createdAt, isAllowJoinEventEnded, updatedAt
    }
    
    var timeZoneNumber: Int {
        return Int(timezone ?? "") ?? 0
    }
    
    var startDateString: String {
        let date = stringToDate(startDate)
        return dateFormatter.string(from: date)
    }
    var startTimeString: String {
        let date = stringToDate(startDate)
        return timeFormatter.string(from: date)
    }
    var endDateString: String {
        let date = stringToDate(endDate)
        return dateFormatter.string(from: date)
    }
    var endTimeString: String {
        let date = stringToDate(endDate)
        return timeFormatter.string(from: date)
    }
    
    private func stringToDate(_ dateString: String?) -> Date {
        guard let dateString = dateString else { return Date() }
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: timeZoneNumber * 3600)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: dateString) ?? Date()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: timeZoneNumber * 3600)
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: timeZoneNumber * 3600)
        formatter.dateFormat = "h:mma"
        return formatter
    }
}

struct LoginResponse: Codable {
    let accessToken: String?
    let info: User?
    enum CodingKeys: String, CodingKey {
        case accessToken, info
    }
}

class UserCovidCert {
    let isValid: Bool
    let certificate: CovidCertificate
    let validFrom: Date
    let validUntil: Date
    
    init(valid: Bool, certificate: CovidCertificate, from: Date, unitl: Date) {
        self.isValid = valid
        self.certificate = certificate
        self.validFrom = from
        self.validUntil = unitl
    }
}

class User: Codable {
    let id: Int?
    let email, firstName, lastName: String?
    let avatarUrl: String?
    let phone, address: String?
    let active: Bool?
    let countryCode, loginVerifyCodeCreatedTime: String?
    let fakeTemporaryEmail: Bool?
    let organizationId: Int?
    let stripeCustomerId, bio, companyName, state: String?
    let city, zip, addressLine, phoneCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, firstName, lastName, avatarUrl
        case phone, address, active, countryCode, loginVerifyCodeCreatedTime, fakeTemporaryEmail
        case organizationId, stripeCustomerId
        case bio, companyName, state, city, zip, addressLine, phoneCode
    }
}

struct CheckinData: Codable {
    let firstName, lastName, email, avatarUrl, ticketName: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, email, avatarUrl, ticketName
    }
}
