//
//  Account.swift
//  LibraryApp
//
//  Created by Vicky Zheng on 12/19/17.
//  Copyright © 2017 Vicky Zheng. All rights reserved.
//

import Foundation
import UIKit
import Social

class Account: UIViewController {
    
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        logOutButton.layer.cornerRadius = 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareToFacebook(_ sender: Any) {
        //alert
        let alert = UIAlertController(title: "Share", message: "Share this app on Facebook!", preferredStyle: .actionSheet)
        
        //action
        let share = UIAlertAction(title: "Share to Facebook", style: .default) {(ACTION) in
            //checks if user is connected to Facebook
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                post?.setInitialText("Come check out this app!")
                self.present(post!, animated: true, completion: nil)
            }
        }
        
        //adds action to the alert
        alert.addAction(share)
        
        //shows the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey:"sid")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
    }
    
}

