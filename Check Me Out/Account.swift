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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sidLabel: UILabel!
    @IBOutlet weak var totalBooksLabel: UILabel!
    @IBOutlet weak var totalReservationsLabel: UILabel!
    @IBOutlet weak var totalFineLabel: UILabel!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        logOutButton.layer.cornerRadius = 2
        
        let sid = defaults.object(forKey: "sid") as? String
        sidLabel.text = sid
        
        var request = URLRequest(url: URL(string: "http://52.22.1.14:3000/library/api/v1/users?sid=" + sid! + "&key=bsvr9N5wrGJVDz98UvBMnGt8")!)
        // Sets the http method to GET which means GETting data FROM the API. There are two methods, GET and POST. POST means POSTing data TO the API. In this case, we're using GET.
        request.httpMethod = "GET"
        // Sets the file type that the data will be retrieved to be JSON, which is the standard format.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Starts the HTTP session (connects to the API URL with the search query and GETs the data).
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            DispatchQueue.main.async {
                do {
                    // Converts and saves the returned data into a variable called 'json' in appropriate JSON formatting.
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    // Creates a dictionary from the JSON file to look up the value for the key given.
                    if let array = json as? [Any] {
                        // Creates an array of the returned terms.
                        if let dict = array[0] as? [String: Any] {
                            // Creates a dictionary of the book data.
                            if let data = dict["data"] as? [Any] {
                                if let user = data[0] as? [String: Any] {
                                    if let firstname = user["firstname"] as? String {
                                        if let lastname = user["lastname"] as? String {
                                            self.nameLabel.text = "\(firstname) \(lastname)"
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("error")
                }
            }
        })
        task.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let sid = defaults.object(forKey: "sid") as? String
        sidLabel.text = sid
        
        var request = URLRequest(url: URL(string: "http://52.22.1.14:3000/library/api/v1/users?sid=" + sid! + "&key=bsvr9N5wrGJVDz98UvBMnGt8")!)
        // Sets the http method to GET which means GETting data FROM the API. There are two methods, GET and POST. POST means POSTing data TO the API. In this case, we're using GET.
        request.httpMethod = "GET"
        // Sets the file type that the data will be retrieved to be JSON, which is the standard format.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Starts the HTTP session (connects to the API URL with the search query and GETs the data).
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            DispatchQueue.main.async {
                do {
                    // Converts and saves the returned data into a variable called 'json' in appropriate JSON formatting.
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    // Creates a dictionary from the JSON file to look up the value for the key given.
                    if let array = json as? [Any] {
                        // Creates an array of the returned terms.
                        if let dict = array[0] as? [String: Any] {
                            // Creates a dictionary of the book data.
                            if let data = dict["data"] as? [Any] {
                                if let user = data[0] as? [String: Any] {
                                    if let firstname = user["firstname"] as? String {
                                        if let lastname = user["lastname"] as? String {
                                            self.nameLabel.text = "\(firstname) \(lastname)"
                                        }
                                    }
                                    if let fine = user["fine"] as? Double {
                                        self.totalFineLabel.text = String(format: "Total Fine: $%.02f", fine)
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("error")
                }
            }
        })
        task.resume()
        
        var request2 = URLRequest(url: URL(string: "http://52.22.1.14:3000/library/api/v1/checkedout?sid=" + sid! + "&key=bsvr9N5wrGJVDz98UvBMnGt8")!)
        // Sets the http method to GET which means GETting data FROM the API. There are two methods, GET and POST. POST means POSTing data TO the API. In this case, we're using GET.
        request2.httpMethod = "GET"
        // Sets the file type that the data will be retrieved to be JSON, which is the standard format.
        request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Starts the HTTP session (connects to the API URL with the search query and GETs the data).
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request2, completionHandler: { data, response, error -> Void in
            DispatchQueue.main.async {
                do {
                    // Converts and saves the returned data into a variable called 'json' in appropriate JSON formatting.
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    // Creates a dictionary from the JSON file to look up the value for the key given.
                    if let array = json as? [Any] {
                        // Creates an array of the returned terms.
                        if let dict = array[0] as? [String: Any] {
                            // Creates a dictionary of the book data.
                            if let data = dict["data"] as? [Any] {
                                self.totalBooksLabel.text = "Total Books Checked Out: \(data.count)"
                            }
                        }
                    }
                } catch {
                    print("error")
                }
            }
        })
        task2.resume()
        
        var request3 = URLRequest(url: URL(string: "http://52.22.1.14:3000/library/api/v1/reservations?sid=" + sid! + "&key=bsvr9N5wrGJVDz98UvBMnGt8")!)
        // Sets the http method to GET which means GETting data FROM the API. There are two methods, GET and POST. POST means POSTing data TO the API. In this case, we're using GET.
        request3.httpMethod = "GET"
        // Sets the file type that the data will be retrieved to be JSON, which is the standard format.
        request3.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Starts the HTTP session (connects to the API URL with the search query and GETs the data).
        let session3 = URLSession.shared
        let task3 = session3.dataTask(with: request3, completionHandler: { data, response, error -> Void in
            DispatchQueue.main.async {
                do {
                    // Converts and saves the returned data into a variable called 'json' in appropriate JSON formatting.
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    // Creates a dictionary from the JSON file to look up the value for the key given.
                    if let array = json as? [Any] {
                        // Creates an array of the returned terms.
                        if let dict = array[0] as? [String: Any] {
                            // Creates a dictionary of the book data.
                            if let data = dict["data"] as? [Any] {
                                self.totalReservationsLabel.text = "Total Reservations: \(data.count)"
                            }
                        }
                    }
                } catch {
                    print("error")
                }
            }
        })
        task3.resume()
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
               
               let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
               post.setInitialText("Come check out this app!")
               self.present(post, animated: true, completion: nil)
                print("yes")
            } else {self.showAlert(service: "Facebook")}
        }

        //adds action to the alert
        alert.addAction(share)
        
        //shows the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareToTwitter(_ sender: Any) {
        //alert
        let alert = UIAlertController(title: "Share", message: "Share this app on Twitter!", preferredStyle: .actionSheet)
        
        //action
        let share = UIAlertAction(title: "Share to Twitter", style: .default) {(ACTION) in
            //checks if user is connected to Twitter
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                post.setInitialText("Come check out this app!")
                self.present(post, animated: true, completion: nil)
                print("yes")
            } else {self.showAlert(service: "Twitter")}
        }
        
        //adds action to the alert
        alert.addAction(share)
        
        //shows the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(service: String) {
        let alert = UIAlertController(title: "Error", message: "You are not connected to \(service).", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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

