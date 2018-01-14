//
//  FirstViewController.swift
//  LibraryApp
//
//  Created by Vicky Zheng on 12/14/17.
//  Copyright © 2017 Vicky Zheng. All rights reserved.
//

import UIKit
import Kingfisher

class FirstViewController: UITableViewController {
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    var myBooks: [String] = []
    var myBookISBNs: [String] = []
    var myBookDueDates: [String] = []
    var reservationCells: [Int] = []
    
    var doneLoad = false
    var numLooped = 0
    
    let defaults = UserDefaults.standard
    
    @IBOutlet var bookTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let sid = defaults.object(forKey: "sid") as? String
        let myApplication = UIApplication.shared.delegate as! AppDelegate
        myApplication.registerPN(UIApplication.shared)
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
                        // Creates a dictionary of the book data.
                        if let data = dict["data"] as? [[String: Any]] {
                            for book in data {
                                if let title = book["title"] as? String {
                                    if let author = book["author"] as? String {
                                        self.myBooks.append("\(title) by \(author)")
                                    }
                                }
                                if let isbn = book["isbn"] as? String {
                                    self.myBookISBNs.append(isbn)
                                }
                                if let duedate = book["duedate"] as? String {
                                    self.myBookDueDates.append("Due: \(String(duedate.prefix(10)))")
                                }
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
            var request2 = URLRequest(url: URL(string: "http://52.22.1.14:3000/library/api/v1/reservations?sid=" + sid! + "&key=bsvr9N5wrGJVDz98UvBMnGt8")!)
            // Sets the http method to GET which means GETting data FROM the API. There are two methods, GET and POST. POST means POSTing data TO the API. In this case, we're using GET.
            request2.httpMethod = "GET"
            // Sets the file type that the data will be retrieved to be JSON, which is the standard format.
            request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Starts the HTTP session (connects to the API URL with the search query and GETs the data).
            let session2 = URLSession.shared
            let task2 = session2.dataTask(with: request2, completionHandler: { data, response, error -> Void in
                do {
                    // Converts and saves the returned data into a variable called 'json' in appropriate JSON formatting.
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    // Creates a dictionary from the JSON file to look up the value for the key given.
                    if let array = json as? [Any] {
                        // Creates an array of the returned terms.
                        if let dict = array[0] as? [String: Any] {
                            // Creates a dictionary of the book data.
                            if let data = dict["data"] as? [[String: Any]] {
                                for book in data {
                                    self.reservationCells.append(self.myBooks.count)
                                    if let title = book["title"] as? String {
                                        if let author = book["author"] as? String {
                                            self.myBooks.append("\(title) by \(author)")
                                        }
                                    }
                                    if let isbn = book["isbn"] as? String {
                                        self.myBookISBNs.append(isbn)
                                    }
                                    if let expiredate = book["expiredate"] as? String {
                                        self.myBookDueDates.append("Reservation expires: \(String(expiredate.prefix(10)))")
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.bookTableView.reloadData()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.bookTableView.reloadData()
                                }
                            }
                        }
                    }
                } catch {
                    print("error")
                }
            })
            task2.resume()
        })
        task.resume()
        
        self.bookTableView.rowHeight = 100
        refreshControl?.addTarget(self, action: #selector(FirstViewController.refresh(_:)), for: .valueChanged)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        // set the text from the data model
        cell.textLabel?.text = self.myBooks[indexPath.row]
        let dueDate = self.myBookDueDates[indexPath.row]
        cell.detailTextLabel?.text = dueDate
        
        var request = URLRequest(url: URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:" + myBookISBNs[indexPath.row] + "&key=AIzaSyCidOJdqXesqJzB_VMyXJtjTbAA1XiVkvY")!)
        // Sets the http method to GET which means GETting data FROM the API. There are two methods, GET and POST. POST means POSTing data TO the API. In this case, we're using GET.
        request.httpMethod = "GET"
        // Sets the file type that the data will be retrieved to be JSON, which is the standard format.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Starts the HTTP session (connects to the API URL with the search query and GETs the data).
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                // Converts and saves the returned data into a variable called 'json' in appropriate JSON formatting.
                let json = try JSONSerialization.jsonObject(with: data!, options: [])                // Creates a dictionary from the JSON file to look up the value for the key given.
                if let dictionary = json as? [String: Any] {
                    // Creates an array of the returned books.
                    if let items = dictionary["items"] as? [Any] {
                        // Creates a dictionary of the books' info.
                        if let nestedDict = items[0] as? [String: Any] {
                            if let volumeInfo = nestedDict["volumeInfo"] as? [String: Any] {
                                if let imageLinks = volumeInfo["imageLinks"] as? [String: String] {
                                    if let smallThumbnail = imageLinks["smallThumbnail"] {
                                        let url = URL(string: smallThumbnail)
                                        DispatchQueue.main.async {
                                            cell.imageView?.kf.indicatorType = .activity
                                            cell.imageView?.kf.setImage(with: url, completionHandler: {
                                                (image, error, cacheType, imageUrl) in
                                                self.numLooped += 1
                                                if (self.doneLoad == false && self.numLooped == self.myBooks.count) {
                                                    self.doneLoad = true
                                                    self.refreshControl?.endRefreshing()
                                                    self.bookTableView.reloadData()
                                                }
                                            })
                                        }
                                    } else {
                                        let url = URL(string: "https://i.imgur.com/JIGQIq7.png")
                                        DispatchQueue.main.async {
                                            cell.imageView?.kf.indicatorType = .activity
                                            cell.imageView?.kf.setImage(with: url, completionHandler: {
                                                (image, error, cacheType, imageUrl) in
                                                self.numLooped += 1
                                                if (self.doneLoad == false && self.numLooped == self.myBooks.count) {
                                                    self.doneLoad = true
                                                    self.refreshControl?.endRefreshing()
                                                    self.bookTableView.reloadData()
                                                }
                                            })
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        self.numLooped += 1
                        if (self.doneLoad == false && self.numLooped == self.myBooks.count) {
                            self.doneLoad = true
                            self.refreshControl?.endRefreshing()
                            DispatchQueue.main.async {
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
        
        return cell
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let sid = defaults.object(forKey: "sid") as? String
        print(self.reservationCells)
        print(self.reservationCells.contains(indexPath.row))
        if self.reservationCells.contains(indexPath.row) {
            let alertController = UIAlertController(title: "Confirm", message: "Are you sure you would like to withdraw this reservation for \(self.myBooks[indexPath.row])?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler:{ action in
                let url = URL(string: "http://52.22.1.14:3000/library/api/v1/delreservations")!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                let postString = "sid=\(sid!)&isbn=\(self.myBookISBNs[indexPath.row])&key=bsvr9N5wrGJVDz98UvBMnGt8"
                request.httpBody = postString.data(using: .utf8)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {                                                 // check for fundamental networking error
                        print("error=\(String(describing: error))")
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(String(describing: response))")
                    }
                    
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(String(describing: responseString))")
                    
                    if responseString == "success" {
                        let alertController = UIAlertController(title: "Withdrawn", message: "You have successfully withdraw your reservation for \(self.myBooks[indexPath.row]).", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Error", message: responseString, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                task.resume()
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        numLooped = 0
        doneLoad = false
        self.myBooks = []
        self.myBookISBNs = []
        self.myBookDueDates = []
        self.reservationCells = []
        
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
                                        self.myBooks.append("\(title) by \(author)")
                                    }
                                }
                                if let isbn = book["isbn"] as? String {
                                    self.myBookISBNs.append(isbn)
                                }
                                if let duedate = book["duedate"] as? String {
                                    self.myBookDueDates.append("Due: \(String(duedate.prefix(10)))")
                                }
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
            var request2 = URLRequest(url: URL(string: "http://52.22.1.14:3000/library/api/v1/reservations?sid=" + sid! + "&key=bsvr9N5wrGJVDz98UvBMnGt8")!)
            // Sets the http method to GET which means GETting data FROM the API. There are two methods, GET and POST. POST means POSTing data TO the API. In this case, we're using GET.
            request2.httpMethod = "GET"
            // Sets the file type that the data will be retrieved to be JSON, which is the standard format.
            request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Starts the HTTP session (connects to the API URL with the search query and GETs the data).
            let session2 = URLSession.shared
            let task2 = session2.dataTask(with: request2, completionHandler: { data, response, error -> Void in
                do {
                    // Converts and saves the returned data into a variable called 'json' in appropriate JSON formatting.
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    // Creates a dictionary from the JSON file to look up the value for the key given.
                    if let array = json as? [Any] {
                        // Creates an array of the returned terms.
                        if let dict = array[0] as? [String: Any] {
                            // Creates a dictionary of the book data.
                            if let data = dict["data"] as? [[String: Any]] {
                                for book in data {
                                    self.reservationCells.append(self.myBooks.count)
                                    if let title = book["title"] as? String {
                                        if let author = book["author"] as? String {
                                            self.myBooks.append("\(title) by \(author)")
                                        }
                                    }
                                    if let isbn = book["isbn"] as? String {
                                        self.myBookISBNs.append(isbn)
                                    }
                                    if let expiredate = book["expiredate"] as? String {
                                        self.myBookDueDates.append("Reservation expires: \(String(expiredate.prefix(10)))")
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.bookTableView.reloadData()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.bookTableView.reloadData()
                                }
                            }
                        }
                    }
                } catch {
                    print("error")
                }
            })
            task2.resume()
            if self.myBooks.count == 0 {
                self.doneLoad = true
                self.refreshControl?.endRefreshing()
                DispatchQueue.main.async {
                    self.bookTableView.reloadData()
                }
            }
        })
        task.resume()
    }
}

