//
//  BookDetailsVC.swift
//  Check Me Out
//
//  Created by Leo Shao on 1/13/18.
//  Copyright © 2018 Leo Shao. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class BookDetailsVC: UIViewController {
    
    @IBOutlet weak var titleAuthorLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    
    var book = ""
    var image: URL? = nil
    var quantity = 0
    var desc = ""
    var rating = 0.0
    var category = ""
    var publisher = ""
    var pageCount = 0
    var isbn = ""
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleAuthorLabel.text = book
        bookImage.kf.indicatorType = .activity
        bookImage.kf.setImage(with: image)
        var attributedString = NSMutableAttributedString(string:"Quantity In Stock:", attributes:[NSAttributedStringKey.font: UIFont(name:"Baskerville-SemiBold", size:18)!])
        attributedString.append(NSMutableAttributedString(string: " \(quantity)"))
        quantityLabel.attributedText = attributedString
        attributedString = NSMutableAttributedString(string:"Description:", attributes:[NSAttributedStringKey.font: UIFont(name:"Baskerville-SemiBold", size:18)!])
        attributedString.append(NSMutableAttributedString(string: " \(desc)"))
        descLabel.attributedText = attributedString
        attributedString = NSMutableAttributedString(string:"Rating:", attributes:[NSAttributedStringKey.font: UIFont(name:"Baskerville-SemiBold", size:18)!])
        attributedString.append(NSMutableAttributedString(string: " \(rating)"))
        ratingLabel.attributedText = attributedString
        attributedString = NSMutableAttributedString(string:"Category:", attributes:[NSAttributedStringKey.font: UIFont(name:"Baskerville-SemiBold", size:18)!])
        attributedString.append(NSMutableAttributedString(string: " \(category)"))
        categoryLabel.attributedText = attributedString
        attributedString = NSMutableAttributedString(string:"Description:", attributes:[NSAttributedStringKey.font: UIFont(name:"Baskerville-SemiBold", size:18)!])
        attributedString.append(NSMutableAttributedString(string: " \(publisher)"))
        publisherLabel.attributedText = attributedString
        attributedString = NSMutableAttributedString(string:"Page Count:", attributes:[NSAttributedStringKey.font: UIFont(name:"Baskerville-SemiBold", size:18)!])
        attributedString.append(NSMutableAttributedString(string: " \(pageCount)"))
        pageCountLabel.attributedText = attributedString
        attributedString = NSMutableAttributedString(string:"ISBN:", attributes:[NSAttributedStringKey.font: UIFont(name:"Baskerville-SemiBold", size:18)!])
        attributedString.append(NSMutableAttributedString(string: " \(isbn)"))
        isbnLabel.attributedText = attributedString
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reserveButtonPressed(_ sender: UIButton) {
        let sid = defaults.object(forKey: "sid") as? String
        let url = URL(string: "http://52.22.1.14:3000/library/api/v1/reservations")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "sid=\(sid!)&isbn=\(isbn)&key=bsvr9N5wrGJVDz98UvBMnGt8"
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
                let alertController = UIAlertController(title: "Reserved", message: "You have successfully reserved \(self.book) for 7 days.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: responseString, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
