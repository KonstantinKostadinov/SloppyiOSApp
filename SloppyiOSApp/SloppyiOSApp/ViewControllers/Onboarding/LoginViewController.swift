//
//  LoginViewController.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 9.08.21.
//

import UIKit
import Lottie

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var singUpButton: UIButton!

    let animationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        setupTextFieldDelegates()
        // Do any additional setup after loading the view.
    }


    private func setupAnimation() {
        animationView.animation = Animation.named("swinging")
        animationView.layer.zPosition = -1
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        animationView.play()
    }

    @IBAction func didTapLoginButton(_ sender: Any) {
        guard let email = try? self.emailTextField.validatedText(validationType: .email) else {
            self.view.showError(error: "Please enter valid email")
            return
        }

//        guard let password = try? self.passwordTextField.validatedText(validationType: .password) else {
//            self.view.showError(error: "Your password should contain 1 uppercase letter, 1 lowercase letter and special symbols")
//            return
//        }
        guard let password = self.passwordTextField.text else { return}
        let credentials: [String:String] = ["userEmail" : email,
                           "userPass" : password]

        RequestManager.login(credentials: credentials) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
//                RequestManager.fetchOwnedAndSharedPlaintIds()
//                RequestManager.fetchOwnedAndSharedPlaints()
//                RequestManager.fetchMainPlants()
                self.performSegue(withIdentifier: "fromLoginToPlantScreenSegue", sender: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
