//
//  DateExtensions.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 7.08.21.
//

import Foundation

extension Date {
    var timezoneOffset: String {
        let seconds = TimeZone.current.secondsFromGMT()
        let hours = seconds/3600
        let minutes = abs(seconds/60) % 60
        let offset = String(format: "%.2d:%.2d", hours, minutes)

        return offset
    }

    var dateInISO8601: String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullTime,
                                       .withTimeZone,
                                       .withFullDate,
                                       .withDashSeparatorInDate,
                                       .withFractionalSeconds]

        return dateFormatter.string(from: self)
    }
}
