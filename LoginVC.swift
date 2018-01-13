//
//  LoginVC.swift
//  LibraryApp
//
//  Created by Vicky Zheng on 12/27/17.
//  Copyright © 2017 Vicky Zheng. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sidField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "sid") as? String) != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabBarController
        }
        loginButton.layer.cornerRadius = 2
        
        sidField.delegate = self
        sidField.returnKeyType = UIReturnKeyType.go
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sidField.resignFirstResponder()
        login()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        login()
    }
    
    func login() {
        var request = URLRequest(url: URL(string: "http://52.22.1.14:3000/library/api/v1/users?sid=" + sidField.text! + "&key=bsvr9N5wrGJVDz98UvBMnGt8")!)
        // Sets the http method to GET which means GETting data FROM the API. There are two methods, GET and POST. POST means POSTing data TO the API. In this case, we're using GET.
        request.httpMethod = "GET"
        // Sets the file type that the data will be retrieved to be JSON, which is the standard format.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Starts the HTTP session (connects to the API URL with the search query and GETs the data).
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                // Converts and saves the returned data into a variable called 'json' in appropriate JSON formatting.
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                // Creates a dictionary from the JSON file to look up the value for the key given.
                if let array = json as? [Any] {
                    // Creates an array of the returned terms.
                    if let dict = array[0] as? [String: Any] {
                        // Creates a dictionary of the current term details (e.g. term, definition, term number).
                        if let result = dict["result"] as? String {
                            if (result == "success") {
                                DispatchQueue.main.async {
                                    let defaults = UserDefaults.standard
                                    defaults.set(self.sidField.text, forKey: "sid")
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.window?.rootViewController = tabBarController
                                }
                            } else {
                                DispatchQueue.main.async {
                                    let alertController = UIAlertController(title: "Wrong ID", message: "Please try again.", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler:nil))
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
        })
        task.resume()
    }

}
