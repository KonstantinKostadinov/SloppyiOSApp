//
//  BundleExtensions.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 7.08.21.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var appName: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
    var bundleId: String? {
        return infoDictionary?["CFBundleIdentifier"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "0.0.1")"
    }
}
