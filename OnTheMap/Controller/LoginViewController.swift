//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 23.04.21.
//


import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
        print("View will appear")
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        print("loginbuttontapped")

        setLoggingIn(true)
      //  OTMClient.getRequestToken(completion: handleRequestTokenResponse(success:error:))
        print("login")
         //   OTMClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
        
        OTMClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleSessionResponse(success:error:))
    }
    
    
 /*   func handleRequestTokenResponse(success: Bool, error: Error?) {
        print("handle")
        if success {
            OTMClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
        } else {
            print("handle fail")
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }*/
    
   /* func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            OTMClient.createSessionId(completion: handleSessionResponse(success:error:))
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }*/
    
    func handleSessionResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showAlert(title: error?.localizedDescription ?? "Generic Error", message: "Please check your email or password and try again." )
           // showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signUpButton.isEnabled = !loggingIn
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        if let url = URL(string: "https://auth.udacity.com/sign-up") {
            UIApplication.shared.open(url)
        }
        print("signupbuttontapped")
    }
    
  /*  func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }*/
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func showRedirectionFailure(message: String) {
        let alertVC = UIAlertController(title: "Redirection Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}

