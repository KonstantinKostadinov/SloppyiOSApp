//
//  StoryboardExtensions.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 7.08.21.
//

import Foundation
import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    static var onboarding: UIStoryboard {
        return UIStoryboard(name: "Onboarding", bundle: nil)
    }

    static var plant: UIStoryboard {
        return UIStoryboard(name: "Plant", bundle: nil)
    }
}
