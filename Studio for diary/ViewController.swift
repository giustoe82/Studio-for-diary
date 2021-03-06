//
//  ViewController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi, Aleks Edholm, Aleksander Frostelén on 2018-09-23.
//  Copyright © 2018 Group g. All rights reserved.
//

import UIKit
import Firebase



/*
 This class takes care of SIGN UP and LOGIN functions
 */
class ViewController: UIViewController {
    
    var signUpMode = true
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }
    
    
    /*
     Rules for SIGN UP and LOGIN when the user clicks on the button SIGN UP/LOGIN
     */
    @IBAction func topTapped(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide both email and password")
        } else {
            if signUpMode && (passwordTextField.text != repeatPasswordTextField.text || repeatPasswordTextField.text == "") {
                
                displayAlert(title: "Error", message: "You must repeat the password")
            } else {
                if let email = emailTextField.text {
                    if let password = passwordTextField.text {
                        if signUpMode{
                            //SIGN UP
                            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                                if error != nil {
                                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                                } else {
                                    print("Sign Up Successful")
                                    self.emailTextField.text = ""
                                    self.passwordTextField.text = ""
                                    self.repeatPasswordTextField.text = ""
                                    self.performSegue(withIdentifier: "Logged", sender: nil)
                                }
                            })
                        } else {
                            //LOG IN
                            Auth.auth().signIn(withEmail: email, password: password, completion:{ (user, error) in
                                if error != nil {
                                    self.displayAlert(title: "error", message: error!.localizedDescription)
                                } else {
                                    print("Log In Successful")
                                    //If LOGIN is successfull the user's details are saved locally in
                                    //UserDefaults
                                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "uid")
                                    self.emailTextField.text = ""
                                    self.passwordTextField.text = ""
                                    self.performSegue(withIdentifier: "Logged", sender: nil)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
  
    
    /*
     The lower button rules the appearance of this view through changing the value of the
     boolean variable "signUpMode"
     */
    @IBAction func downTapped(_ sender: Any) {
        
        if signUpMode {
            topButton.setTitle("Log In", for: .normal)
            downButton.setTitle("Switch to Sign Up", for: .normal)
            repeatPasswordTextField.isHidden = true
            signUpMode = false
            
        } else {
            topButton.setTitle("Sign Up", for: .normal)
            downButton.setTitle("Switch to Log In", for: .normal)
            repeatPasswordTextField.isHidden = false
            signUpMode = true
        }
    }
    
    /*
     function for the displayAlert: this is like a template
     */
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    /*
     Functions "touchesBegan" and "textFieldShouldReturn" regulate keyboard behaviour
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    /*
     After the user LOGGED IN for the first time then he will be redirected to the next view
     every other time he starts the app
     */
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "uid") != nil {
            DispatchQueue.main.async() {
                //Very Interesting!!!!!🤔
                [unowned self] in
                self.performSegue(withIdentifier: "Logged", sender: nil)
            }
        }
    }
    
}

