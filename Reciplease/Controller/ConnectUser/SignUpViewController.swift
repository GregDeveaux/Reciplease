//
//  SignUpViewController.swift
//  Reciplease
//
//  Created by Greg Deveaux on 29/12/2022.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

        // -------------------------------------------------------
        // MARK: - database and Authentification Firebase
        // -------------------------------------------------------

    let referenceDatabase: DatabaseReference = Database.database().reference()
    let authentification: Auth = .auth()


        // -------------------------------------------------------
        // MARK: - properties
        // -------------------------------------------------------

    lazy var logoReciplease: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logoReciplease")
        imageView.contentMode = .scaleAspectFit
        imageView.isAccessibilityElement = true
        imageView.accessibilityTraits = .image
        imageView.accessibilityHint = "Sign up to ReciPlease, save your favorite by registering"
        return imageView
    }()

    lazy var emailTextField: UITextField = .setupTextFields(placeholder: "Email",
                                                            isSecure: false,
                                                            accessibilityMessage: "write here your email address")

    lazy var usernameTextField: UITextField = .setupTextFields(placeholder: "Username",
                                                               isSecure: false,
                                                               accessibilityMessage: "write here your username")

    lazy var passwordTextField: UITextField = .setupTextFields(placeholder: "Password",
                                                               isSecure: true,
                                                               accessibilityMessage: "write here your password")
    private var isSignUp = false {
        didSet {
            signUpButton.setNeedsUpdateConfiguration()
        }
    }

    lazy var signUpButton: UIButton = {
        let myButton: UIButton = .setupButton(style: UIButton.Configuration.filled(),
                                              title: "Sign up",
                                              colorText: .darkBlue,
                                              colorBackground: .greenColor,
                                              image: "person.fill.questionmark",
                                              accessibilityMessage: "the button launches receipt of recipes",
                                              activity: isSignUp)
        myButton.addAction(
            UIAction { _ in
                self.handleSignUp()
                print("✅ User go sign up")
            }, for: .touchUpInside)
        return myButton
    }()

    func handleSignUp() {
        guard let email = emailTextField.text?.lowercased(), !email.isEmpty else {
            presentAlert(with: "Oh no! you just forget\n to write your email")
            return
        }
        guard let username = usernameTextField.text, !username.isEmpty else {
            presentAlert(with: "Oh no! you just forget\n to write your username")
            return
        }
        guard let password = passwordTextField.text, password.count >= 6 else {
            presentAlert(with: "Oh no! you just forget\n to write your password\n or the password not contains\n 6 min characters")
            return
        }
            // Save a new user informations
        authentification.createUser(withEmail: email, password: password) { user, error in
            guard let user = user, error == nil else {
                if let error = error {
                    print("🛑 LOGIN_VC/FIREBASE_AUTH: Failed to create login, \(error)")
                }
                return
            }
                // and save his username in data according to the userID (used to whole app)
            let userUid = user.user.uid
            print("✅ LOGIN_VC/FIREBASE_AUTH: The user has been create: \(userUid)")

            let target = "users/\(userUid)/username"
            let usernameReference = self.referenceDatabase.child(target)

            usernameReference.setValue(username) { error, reference in
                if let error = error {
                    print("🛑 LOGIN_VC/FIREBASE_DATABASE: Failed to save data of user, \(error)")
                    return
                }
                print("✅ LOGIN_VC/FIREBASE_DATABASE: Save the user datas has been success")
            }

            self.performSegue(withIdentifier: "SignUpSegueTabBar", sender: self)
            print("✅ LOGIN_VC/FIREBASE_AUTH: \(self.usernameTextField.text ?? "Nothing") has logged")
        }
    }


        // -------------------------------------------------------
        //MARK: - life cycle
        // -------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    

        // -------------------------------------------------------
        //MARK: - setup design
        // -------------------------------------------------------

    private func setupView() {
        view.backgroundColor = UIColor.darkBlue
        setupLogo()
        setupTextFieldsStackView()
    }

    private func setupLogo() {
        view.addSubview(logoReciplease)
        logoReciplease.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        logoReciplease.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logoReciplease.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logoReciplease.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func setupTextFieldsStackView() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoReciplease.bottomAnchor, constant: 20),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}


    // -------------------------------------------------------
    // MARK: Keyboard setup dismiss
    // -------------------------------------------------------
    // if touch outside stop display keyboard

extension SignUpViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
