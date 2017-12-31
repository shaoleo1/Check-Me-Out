//
//  FirstViewController.swift
//  LibraryApp
//
//  Created by Vicky Zheng on 12/14/17.
//  Copyright © 2017 Vicky Zheng. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    var myBooks: [String] = []
    
    @IBOutlet var bookTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshControl?.addTarget(self, action: #selector(FirstViewController.refresh(_:)), for: .valueChanged)
        
        let defaults = UserDefaults.standard
        let sid = defaults.object(forKey: "sid") as? String
        var request = URLRequest(url: URL(string: "http://52.22.1.14:3000/library/api/v1/checkedout?sid=" + sid! + "&key=bsvr9N5wrGJVDz98UvBMnGt8")!)
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
                        if let data = dict["data"] as? [[String: Any]] {
                            for book in data {
                                if let title = book["title"] as? String {
                                    if let author = book["author"] as? String {
                                        self.myBooks.append("\(title) - \(author)")
                                    }
                                }
                            }
                            DispatchQueue.main.async{
                                self.bookTableView.reloadData()
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
        })
        task.resume()
        self.bookTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myBooks.count
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.bookTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.myBooks[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        let defaults = UserDefaults.standard
        let sid = defaults.object(forKey: "sid") as? String
        var request = URLRequest(url: URL(string: "http://52.22.1.14:3000/library/api/v1/checkedout?sid=" + sid! + "&key=bsvr9N5wrGJVDz98UvBMnGt8")!)
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
                        if let data = dict["data"] as? [[String: Any]] {
                            self.myBooks = []
                            for book in data {
                                if let title = book["title"] as? String {
                                    if let author = book["author"] as? String {
                                        self.myBooks.append("\(title) - \(author)")
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                self.bookTableView.reloadData()
                                refreshControl.endRefreshing()
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

