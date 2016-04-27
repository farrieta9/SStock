//
//  FBLoginViewController.swift
//  SStock
//
//  Created by Francisco Arrieta on 4/25/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

// To fix the fbauth2 error
// http://stackoverflow.com/questions/32006033/ios-9-fbauth2-missing-from-info-plist
//https://www.youtube.com/watch?v=cpANieebE2M

class FBLoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        if FBSDKAccessToken.currentAccessToken() == nil{
            print("Not logged in")
        } else {
            print("logged in...")
            self.returnUserData()
            
        }
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
        // Do any additional setup after loading the view.
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, email"])
        graphRequest.startWithCompletionHandler({(connection, result, error) -> Void in
            
            if ((error) != nil){
                print("Failed to get user info")
            } else {
                let userName: String = result.valueForKey("name") as! String
                let email: String = result.valueForKey("email") as! String
                print(userName)
                print(email)
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if FBSDKAccessToken.currentAccessToken() != nil{
            self.performSegueWithIdentifier("loginVC", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil{
            print("loggin complete")
            self.performSegueWithIdentifier("loginVC", sender: self)
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out...")
    }
    
    

}
