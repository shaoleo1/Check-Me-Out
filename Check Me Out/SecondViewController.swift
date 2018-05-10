//
//  SecondViewController.swift
//  LibraryApp
//
//  Created by Vicky Zheng on 12/14/17.
//  Copyright © 2017 Vicky Zheng. All rights reserved.
//

import UIKit
import Kingfisher

class SecondViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var books: [String] = []
    var bookAuthors: [String] = []
    var bookISBNs: [String] = []
    var bookThumbnails: [String] = []
    var bookDescriptions: [String] = []
    var bookPageCounts: [Int] = []
    var bookStockQuantities: [Int] = []
    var bookRatings: [Double] = []
    var bookCategories: [String] = []
    var bookPublishers: [String] = []
    
    var doneLoad = false
    var numLooped = 0
    
    let cellReuseIdentifier = "cell"

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 100
        
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        doneLoad = false
        numLooped = 0
        books = []
        bookAuthors = []
        bookISBNs = []
        bookThumbnails = []
        bookDescriptions = []
        bookPageCounts = []
        bookStockQuantities = []
        bookRatings = []
        bookCategories = []
        bookPublishers = []
        
        // Closes the keyboard
        searchBar.resignFirstResponder()
        
        var request = URLRequest(url: URL(string: "http://52.22.1.14:3000/library/api/v1/books?keywords=" + searchBar.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)! + "&key=bsvr9N5wrGJVDz98UvBMnGt8")!)
        // Sets the http method to GET which means GETting data FROM the API. There are two methods, GET and POST. POST means POSTing data TO the API. In this case, we're using GET.
        request.httpMethod = "GET"
        // Sets the file type that the data will be retrieved to be JSON, which is the standard format.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Starts the HTTP session (connects to the API URL with the search query and GETs the data).
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            DispatchQueue.main.sync {
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
                                    if let isbn = book["isbn"] as? String {
                                        var request2 = URLRequest(url: URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn + "&key=AIzaSyCidOJdqXesqJzB_VMyXJtjTbAA1XiVkvY")!)
                                        // Sets the http method to GET which means GETting data FROM the API. There are two methods, GET and POST. POST means POSTing data TO the API. In this case, we're using GET.
                                        request2.httpMethod = "GET"
                                        // Sets the file type that the data will be retrieved to be JSON, which is the standard format.
                                        request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                        
                                        // Starts the HTTP session (connects to the API URL with the search query and GETs the data).
                                        let session2 = URLSession.shared
                                        let task2 = session2.dataTask(with: request2, completionHandler: { data, response, error -> Void in
                                            DispatchQueue.main.sync {
                                                do {
                                                    // Converts and saves the returned data into a variable called 'json' in appropriate JSON formatting.
                                                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                                                    // Creates a dictionary from the JSON file to look up the value for the key given.
                                                    if let dictionary = json as? [String: Any] {
                                                        // Creates an array of the returned terms.
                                                        if let items = dictionary["items"] as? [[String: Any]] {
                                                            // Creates a dictionary of the current term details (e.g. term, definition, term number).
                                                            for item in items {
                                                                if let volumeInfo = item["volumeInfo"] as? [String: Any] {
                                                                    if let title = volumeInfo["title"] as? String {
                                                                        self.books.append(title)
                                                                    } else {
                                                                        self.books.append("")
                                                                    }
                                                                    if let authors = volumeInfo["authors"] as? [String] {
                                                                        var combinedAuthors = ""
                                                                        for (index, author) in authors.enumerated() {
                                                                            if (index == 0) {
                                                                                combinedAuthors += author
                                                                            } else {
                                                                                combinedAuthors = combinedAuthors + " and " + author
                                                                            }
                                                                        }
                                                                        self.bookAuthors.append(combinedAuthors)
                                                                    } else {
                                                                        self.bookAuthors.append("")
                                                                    }
                                                                    if let industryIdentifiers = volumeInfo["industryIdentifiers"] as? [[String: String]] {
                                                                        var exists = false
                                                                        for isbn in industryIdentifiers {
                                                                            if isbn["type"] == "ISBN_13" {
                                                                                if let id = isbn["identifier"] {
                                                                                    self.bookISBNs.append(id)
                                                                                    exists = true
                                                                                }
                                                                            }
                                                                        }
                                                                        if !exists {
                                                                            self.bookISBNs.append("")
                                                                        }
                                                                    } else {
                                                                        self.bookISBNs.append("")
                                                                    }
                                                                    if let imageLinks = volumeInfo["imageLinks"] as? [String: String] {
                                                                        self.bookThumbnails.append(imageLinks["smallThumbnail"]!)
                                                                    } else {
                                                                        self.bookThumbnails.append("https://i.imgur.com/JIGQIq7.png")
                                                                    }
                                                                    if let description = volumeInfo["description"] as? String {
                                                                        self.bookDescriptions.append(description)
                                                                    } else {
                                                                        self.bookDescriptions.append("")
                                                                    }
                                                                    if let pageCount = volumeInfo["pageCount"] as? Int {
                                                                        self.bookPageCounts.append(pageCount)
                                                                    } else {
                                                                        self.bookPageCounts.append(0)
                                                                    }
                                                                    if let averageRating = volumeInfo["averageRating"] as? Double {
                                                                        self.bookRatings.append(averageRating)
                                                                    } else {
                                                                        self.bookRatings.append(0)
                                                                    }
                                                                    if let categories = volumeInfo["categories"] as? [String] {
                                                                        var combinedCategories = ""
                                                                        for (index, category) in categories.enumerated() {
                                                                            if (index == 0) {
                                                                                combinedCategories += category
                                                                            } else {
                                                                                combinedCategories = combinedCategories + " and " + category
                                                                            }
                                                                        }
                                                                        self.bookCategories.append(combinedCategories)
                                                                    } else {
                                                                        self.bookCategories.append("")
                                                                    }
                                                                    if let publisher = volumeInfo["publisher"] as? String {
                                                                        self.bookPublishers.append(publisher)
                                                                    } else {
                                                                        self.bookPublishers.append("")
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
                                        task2.resume()
                                        
                                    }
                                }
                            }
                        }
                    }
                    var request2 = URLRequest(url: URL(string: "https://www.googleapis.com/books/v1/volumes?q=" + searchBar.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)! + "&key=AIzaSyCidOJdqXesqJzB_VMyXJtjTbAA1XiVkvY")!)
                    // Sets the http method to GET which means GETting data FROM the API. There are two methods, GET and POST. POST means POSTing data TO the API. In this case, we're using GET.
                    request2.httpMethod = "GET"
                    // Sets the file type that the data will be retrieved to be JSON, which is the standard format.
                    request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    // Starts the HTTP session (connects to the API URL with the search query and GETs the data).
                    let session2 = URLSession.shared
                    let task2 = session2.dataTask(with: request2, completionHandler: { data, response, error -> Void in
                        DispatchQueue.main.sync {
                            do {
                                // Converts and saves the returned data into a variable called 'json' in appropriate JSON formatting.
                                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                                // Creates a dictionary from the JSON file to look up the value for the key given.
                                if let dictionary = json as? [String: Any] {
                                    // Creates an array of the returned terms.
                                    if let items = dictionary["items"] as? [[String: Any]] {
                                        // Creates a dictionary of the current term details (e.g. term, definition, term number).
                                        for item in items {
                                            if let volumeInfo = item["volumeInfo"] as? [String: Any] {
                                                var go = true
                                                if let industryIdentifiers = volumeInfo["industryIdentifiers"] as? [[String: String]] {
                                                    var exists = false
                                                    for isbn in industryIdentifiers {
                                                        if isbn["type"] == "ISBN_13" {
                                                            if let id = isbn["identifier"] {
                                                                if !self.bookISBNs.contains(id) {
                                                                    self.bookISBNs.append(id)
                                                                } else {
                                                                    go = false
                                                                }
                                                                exists = true
                                                            }
                                                        }
                                                    }
                                                    if !exists {
                                                        self.bookISBNs.append("")
                                                    }
                                                } else {
                                                    self.bookISBNs.append("")
                                                }
                                                if go {
                                                    if let title = volumeInfo["title"] as? String {
                                                        self.books.append(title)
                                                    } else {
                                                        self.books.append("")
                                                    }
                                                    if let authors = volumeInfo["authors"] as? [String] {
                                                        var combinedAuthors = ""
                                                        for (index, author) in authors.enumerated() {
                                                            if (index == 0) {
                                                                combinedAuthors += author
                                                            } else {
                                                                combinedAuthors = combinedAuthors + " and " + author
                                                            }
                                                        }
                                                        self.bookAuthors.append(combinedAuthors)
                                                    } else {
                                                        self.bookAuthors.append("")
                                                    }
                                                    if let imageLinks = volumeInfo["imageLinks"] as? [String: String] {
                                                        self.bookThumbnails.append(imageLinks["smallThumbnail"]!)
                                                    } else {
                                                        self.bookThumbnails.append("https://i.imgur.com/JIGQIq7.png")
                                                    }
                                                    if let description = volumeInfo["description"] as? String {
                                                        self.bookDescriptions.append(description)
                                                    } else {
                                                        self.bookDescriptions.append("")
                                                    }
                                                    if let pageCount = volumeInfo["pageCount"] as? Int {
                                                        self.bookPageCounts.append(pageCount)
                                                    } else {
                                                        self.bookPageCounts.append(0)
                                                    }
                                                    if let averageRating = volumeInfo["averageRating"] as? Double {
                                                        self.bookRatings.append(averageRating)
                                                    } else {
                                                        self.bookRatings.append(0)
                                                    }
                                                    if let categories = volumeInfo["categories"] as? [String] {
                                                        var combinedCategories = ""
                                                        for (index, category) in categories.enumerated() {
                                                            if (index == 0) {
                                                                combinedCategories += category
                                                            } else {
                                                                combinedCategories = combinedCategories + " and " + category
                                                            }
                                                        }
                                                        self.bookCategories.append(combinedCategories)
                                                    } else {
                                                        self.bookCategories.append("")
                                                    }
                                                    if let publisher = volumeInfo["publisher"] as? String {
                                                        self.bookPublishers.append(publisher)
                                                    } else {
                                                        self.bookPublishers.append("")
                                                    }
                                                }
                                            }
                                        }
                                        self.tableView.reloadData()
                                    }
                                }
                            } catch {
                                print("error")
                            }
                        }
                    })
                    task2.resume()
                } catch {
                    print("error")
                }
            }
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        if books.count > 0 {
            // set the text from the data model
            cell.textLabel?.text = "\(self.books[indexPath.row]) by \(self.bookAuthors[indexPath.row])"
            var request = URLRequest(url: URL(string: "http://52.22.1.14:3000/library/api/v1/books?isbn=" + self.bookISBNs[indexPath.row] + "&key=bsvr9N5wrGJVDz98UvBMnGt8")!)
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
                            if let data = dict["data"] as? [Any] {
                                if let book = data[0] as? [String: Any] {
                                    if let quantity = book["currentquantity"] as? Int {
                                        DispatchQueue.main.async {
                                            cell.detailTextLabel?.text = "In stock: \(quantity)"
                                        }
                                        self.bookStockQuantities.append(quantity)
                                    } else {
                                        DispatchQueue.main.async {
                                            cell.detailTextLabel?.text = "In stock: 0"
                                        }
                                        self.bookStockQuantities.append(0)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        cell.detailTextLabel?.text = "In stock: 0"
                                    }
                                    self.bookStockQuantities.append(0)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    cell.detailTextLabel?.text = "In stock: 0"
                                }
                                self.bookStockQuantities.append(0)
                            }
                        } else {
                            DispatchQueue.main.async {
                                cell.detailTextLabel?.text = "In stock: 0"
                            }
                            self.bookStockQuantities.append(0)
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.detailTextLabel?.text = "In stock: 0"
                        }
                        self.bookStockQuantities.append(0)
                    }
                } catch {
                    print("error")
                    DispatchQueue.main.async {
                        cell.detailTextLabel?.text = "In stock: 0"
                    }
                    self.bookStockQuantities.append(0)
                }
            })
            task.resume()
            
            let url = URL(string: self.bookThumbnails[indexPath.row])
            cell.imageView?.kf.indicatorType = .activity
            cell.imageView?.kf.setImage(with:url, completionHandler: {
                (image, error, cacheType, imageUrl) in
                self.numLooped += 1
                if (self.doneLoad == false && self.numLooped == self.books.count) {
                    self.doneLoad = true
                    self.tableView.reloadData()
                }
            })
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bookDetailsVC = storyboard.instantiateViewController(withIdentifier: "BookDetailsVC") as! BookDetailsVC
        bookDetailsVC.book = "\(books[indexPath.row]) by \(bookAuthors[indexPath.row])"
        if self.bookThumbnails[indexPath.row] != "" {
            bookDetailsVC.image = URL(string: self.bookThumbnails[indexPath.row])
        }
        bookDetailsVC.quantity = bookStockQuantities[indexPath.row]
        bookDetailsVC.desc = bookDescriptions[indexPath.row]
        bookDetailsVC.rating = bookRatings[indexPath.row]
        bookDetailsVC.category = bookCategories[indexPath.row]
        bookDetailsVC.publisher = bookPublishers[indexPath.row]
        bookDetailsVC.pageCount = bookPageCounts[indexPath.row]
        bookDetailsVC.isbn = bookISBNs[indexPath.row]
        self.present(bookDetailsVC, animated: true, completion: nil)
    }
    
}

