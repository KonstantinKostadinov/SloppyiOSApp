//
//  OverlayView.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 4.09.21.
//

import Foundation
import UIKit

class OverlayView: UIViewController {

    var shouldClearBackground = false //set this before initiating the view controller

    override func viewWillAppear(_ animated: Bool) {
        guard self.shouldClearBackground else { return }
        self.view.backgroundColor = .clear
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard self.shouldClearBackground, self.view.backgroundColor != .black else { return }

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.45, delay: 0.3, options: .curveLinear, animations: {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard self.shouldClearBackground else {
            return
        }

        self.view.backgroundColor = .clear
    }
}
