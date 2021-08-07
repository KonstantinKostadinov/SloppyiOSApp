//
//  UIApplicationExtensions.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 7.08.21.
//

import Foundation
import UIKit

public extension UIApplication {
    static var statusBarHeight: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if #available(iOS 13.0, *) {
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }

        return base
    }

    class func getCurrentViewControllerStack(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> [UIViewController?] {
        var result : [UIViewController?] = [base]

        if let nav = base as? UINavigationController {
            result.append(contentsOf: getCurrentViewControllerStack(base: nav.visibleViewController))
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            result.append(contentsOf: getCurrentViewControllerStack(base: selected))
        } else if let presented = base?.presentedViewController {
            result.append(contentsOf: getCurrentViewControllerStack(base: presented))
        }

        return result
    }
}
