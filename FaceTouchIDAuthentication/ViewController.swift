//
//  ViewController.swift
//  FaceTouchIDAuthentication
//
//  Created by mac-00014 on 06/01/20.
//  Copyright © 2020 Mi. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var btnAuth: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    
    /// The available states of being logged in or not.
    enum AuthenticationState {
        case loggedin, loggedout
    }
    /// The current authentication state.
    var state = AuthenticationState.loggedout {
        didSet{
            btnAuth.isSelected = state == .loggedin  // The button text changes on selected.
            lblMessage.text = state == .loggedin ? "Authenticate successfully" : ""
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnLoginLogOutClicked(_ sender: UIButton) {
        
        if state == .loggedin {
            // Log out immediately.
            state = .loggedout
        } else {
            
            // Get a fresh context for each login. If you use the same context on multiple attempts
            //  (by commenting out the next line), then a previously successful authentication
            //  causes the next policy evaluation to succeed without testing biometry again.
            //  That's usually not what you want.
            let context = LAContext()
            
            context.localizedCancelTitle = "Enter Username/Password"
            
            // First check if we have the needed hardware support.
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                
                let reason = "Authentication is required to secure your data"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    
                    if success {
                        
                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
                            self.state = .loggedin
                        }
                        
                    } else {
                        print(error?.localizedDescription ?? "Failed to authenticate")
                        
                        // Fall back to a asking for username and password.
                        // ...
                        DispatchQueue.main.async { [unowned self] in
                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Failed to authenticate", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Can't evaluate policy")
                
                // Fall back to a asking for username and password.
                // ...
            }
        }
    }
}

