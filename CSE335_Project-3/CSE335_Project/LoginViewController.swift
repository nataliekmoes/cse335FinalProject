//
//  LoginViewController.swift
//  CSE335_Project
//
//

import UIKit
import GoogleSignIn
import CoreData


class LoginViewController: UIViewController {
    
    var googleSignIn = GIDSignIn.sharedInstance
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func googleSignIn(_ sender: Any) {
        // google sign in
        let signInConfig = GIDConfiguration(clientID: "653500618629-i3qbn1kvgeui7dc8crmu2p2hjo84r8pl.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
                
            /*
             user.authentication.do { authentication, error in
             guard error == nil else {
             print(error.debugDescription)
             return
             }
             guard let authentication = authentication else {
             print("Authentication failed.  @LoginViewController:googleSignIn()")
             return
             
             }
            */
            
            
            self.getScopes() {
            
                // If sign in succeeded, display the app's main content View.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                
                // Get the SceneDelegate object and change to main tab bar
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                print("Signed user in - displaying MainTabBarController")
            }
            
        }
    }
    
    
    func getScopes(completion: @escaping () -> Void) {
        
        let taskScope = "https://www.googleapis.com/auth/tasks"
        let grantedScopes = self.googleSignIn.currentUser?.grantedScopes
        if grantedScopes == nil || !grantedScopes!.contains(taskScope) {
            // Request additional Tasks scope.
            let additionalScopes = [taskScope]
            GIDSignIn.sharedInstance.addScopes(additionalScopes, presenting: self) { user, error in
                guard error == nil else {
                    print(error.debugDescription)
                    return
                }
                guard let user = user else {
                    //print("Access to additional Tasks scope failed.")
                    return
                }
                
                // Check if the user granted access to the scopes you requested.
                if !user.grantedScopes!.contains(taskScope) {
                    print("Access to scope: \(taskScope)  was not given by user.")
                }
                completion()
            }
        }
    }
    
}




