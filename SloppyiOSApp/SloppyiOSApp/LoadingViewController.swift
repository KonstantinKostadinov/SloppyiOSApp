//
//  ViewController.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 7.08.21.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {
    let animationView = AnimationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.showHUD(progressLabel: "Loading data")
        setupAnimation()
        checkIfUserIsLoggedIn()

    }

    private func setupAnimation() {
        animationView.animation = Animation.named("loading")
        animationView.layer.zPosition = -1
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.play()
        view.addSubview(animationView)
    }
    
    private func checkIfUserIsLoggedIn() {
        if UserDefaultsData.isUserLoggedIn {
//            RequestManager.fetchMainPlants()
//            RequestManager.fetchOwnedAndSharedPlaintIds()
//            RequestManager.fetchOwnedAndSharedPlaints { success, error in
//                print(success, error)
//            }
          DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.performSegue(withIdentifier: "toMainAppScreen", sender: nil)
           }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.dismissHUD(isAnimated: true)
                self.performSegue(withIdentifier: "toLoginSegue", sender: nil)
            }
        }
    }
}

