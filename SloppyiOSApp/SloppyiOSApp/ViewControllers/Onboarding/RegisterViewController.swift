//
//  RegisterViewController.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 9.08.21.
//

import UIKit
import Lottie

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    let animationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupAnimation()
        setupTextFieldDelegates()
    }
    
    private func setupAnimation() {
        animationView.animation = Animation.named("swinging")
        animationView.layer.zPosition = 0
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        view.sendSubviewToBack(animationView)
    }

    private func setupTextFieldDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }

    @IBAction func didTapRegisterButton(_ sender: Any) {
        guard let email = try? self.emailTextField.validatedText(validationType: .email) else {
            self.view.showError(error: "Please enter valid email")
            return
        }

        guard let password = try? self.passwordTextField.validatedText(validationType: .password) else {
            self.view.showError(error: "Your password should contain 1 uppercase letter, 1 lowercase letter and special symbols")
            return
        }

        guard let confirmPassword = try? self.confirmPasswordTextField.validatedText(validationType: .password) else {
             self.view.showError(error: "Your password should contain 1 uppercase letter, 1 lowercase letter and special symbols")
             return
         }

        if password != confirmPassword {
                self.view.showError(error: "Passwords don't match")
        }

        let credentials: [String:String] = ["email" : email,
                                            "password" : password,
                                            "confirmPassword" : confirmPassword]
        RequestManager.register(credentials: credentials) { (success, error) in
            if let error = error {
                self.view.showError(error: error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "fromRegisterToPlantScreenSegue", sender: nil)
            }
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
