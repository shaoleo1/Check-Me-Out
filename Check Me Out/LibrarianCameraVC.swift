//
//  LibrarianCameraVC.swift
//  Check Me Out
//
//  Created by Leo Shao on 1/17/18.
//  Copyright © 2018 Leo Shao. All rights reserved.
//

import UIKit
import AVFoundation

class LibrarianCameraVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var searching = false
    let defaults = UserDefaults.standard
    
    var cameraView: CameraView!
    let session = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: AVCaptureSession.self.description(), attributes: [], target: nil)
    
    //initializes the view
    override func loadView() {
        cameraView = CameraView()
        view = cameraView
    }
    
    //initializes capture session
    override func viewDidLoad() {
        super.viewDidLoad()
        session.beginConfiguration()
        
        let videoDevice = AVCaptureDevice.default(for: .video)
        
        if (videoDevice != nil) {
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!)
            
            if (videoDeviceInput != nil) {
                if (session.canAddInput(videoDeviceInput!)) {
                    session.addInput(videoDeviceInput!)
                }
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (session.canAddOutput(metadataOutput)) {
                session.addOutput(metadataOutput)
                
                metadataOutput.metadataObjectTypes = [
                    .ean13
                ]
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            }
        }
        
        session.commitConfiguration()
        
        cameraView.layer.session = session
        cameraView.layer.videoGravity = .resizeAspectFill
    }
    
    //starts and stops session capture
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sessionQueue.async {
            self.session.stopRunning()
        }
    }
    
    //changes orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Update camera orientation
        let videoOrientation: AVCaptureVideoOrientation
        switch UIDevice.current.orientation {
        case .portrait:
            videoOrientation = .portrait
            
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
            
        case .landscapeLeft:
            videoOrientation = .landscapeRight
            
        case .landscapeRight:
            videoOrientation = .landscapeLeft
            
        default:
            videoOrientation = .portrait
        }
        
        cameraView.layer.connection?.videoOrientation = videoOrientation
    }
    
    
    //capture barcode
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if (metadataObjects.count > 0 && metadataObjects.first is AVMetadataMachineReadableCodeObject) {
            let scan = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            
            let isbn = scan.stringValue
            
            print(isbn!)
            
            if (!searching) {
                searching = true
                var request1 = URLRequest(url: URL(string: "http://52.22.1.14:3000/library/api/v1/books?isbn=" + isbn! + "&key=bsvr9N5wrGJVDz98UvBMnGt8")!)
                request1.httpMethod = "GET"
                request1.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let session1 = URLSession.shared
                let task1 = session1.dataTask(with: request1, completionHandler: { data, response, error -> Void in
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        if let array = json as? [[String: Any]] {
                            if let result = array[0]["result"] as? String {
                                print(result)
                                if result == "success" {
                                    var request = URLRequest(url: URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn! + "&key=AIzaSyCidOJdqXesqJzB_VMyXJtjTbAA1XiVkvY")!)
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
                                            if let dictionary = json as? [String: Any] {
                                                // Creates an array of the returned terms.
                                                if let items = dictionary["items"] as? [Any] {
                                                    // Creates a dictionary of the current term details (e.g. term, definition, term number).
                                                    if let nestedDict = items[0] as? [String: Any] {
                                                        if let volumeInfo = nestedDict["volumeInfo"] as? [String: Any] {
                                                            // Looks up the term and saves it into the variable 'term'.
                                                            if let title = volumeInfo["title"] as? String {
                                                                if let authors = volumeInfo["authors"] as? [String] {
                                                                    var combinedAuthors = ""
                                                                    for (index, author) in authors.enumerated() {
                                                                        if (index == 0) {
                                                                            combinedAuthors += author
                                                                        } else {
                                                                            combinedAuthors = combinedAuthors + " and " + author
                                                                        }
                                                                    }
                                                                    let alertController = UIAlertController(title: title, message: combinedAuthors, preferredStyle: .alert)
                                                                    alertController.addTextField { (textField) in
                                                                        textField.placeholder = "Enter student ID"
                                                                    }
                                                                    alertController.addAction(UIAlertAction(title: "Check In", style: .cancel, handler:{ action in
                                                                        let sid = alertController.textFields?[0].text
                                                                        let url = URL(string: "http://52.22.1.14:3000/library/api/v1/delcheckedout")!
                                                                        var request = URLRequest(url: url)
                                                                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                                                                        request.httpMethod = "POST"
                                                                        let postString = "sid=\(sid!)&isbn=\(isbn!)&key=bsvr9N5wrGJVDz98UvBMnGt8"
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
                                                                                let alertController = UIAlertController(title: "Checked In", message: "You have successfully checked in \(title) by \(combinedAuthors) back to the library.", preferredStyle: .alert)
                                                                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                                                                                    self.searching = false
                                                                                }))
                                                                                self.present(alertController, animated: true, completion: nil)
                                                                            } else {
                                                                                let alertController = UIAlertController(title: "Error", message: responseString, preferredStyle: .alert)
                                                                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                                                                                    self.searching = false
                                                                                }))
                                                                                self.present(alertController, animated: true, completion: nil)
                                                                            }
                                                                        }
                                                                        task.resume()
                                                                    }))
                                                                    alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler:{ action in
                                                                        self.searching = false
                                                                    }))
                                                                    self.present(alertController, animated: true, completion: nil)
                                                                } else {
                                                                    let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
                                                                    let sid = alertController.textFields?[0].text
                                                                    alertController.addAction(UIAlertAction(title: "Check In", style: .cancel, handler:{ action in
                                                                        let url = URL(string: "http://52.22.1.14:3000/library/api/v1/delcheckedout")!
                                                                        var request = URLRequest(url: url)
                                                                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                                                                        request.httpMethod = "POST"
                                                                        let postString = "sid=\(sid!)&isbn=\(isbn!)&key=bsvr9N5wrGJVDz98UvBMnGt8"
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
                                                                                let alertController = UIAlertController(title: "Checked In", message: "You have successfully checked in \(title) back to the library.", preferredStyle: .alert)
                                                                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                                                                                    self.searching = false
                                                                                }))
                                                                                self.present(alertController, animated: true, completion: nil)
                                                                            } else {
                                                                                let alertController = UIAlertController(title: "Error", message: responseString, preferredStyle: .alert)
                                                                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                                                                                    self.searching = false
                                                                                }))
                                                                                self.present(alertController, animated: true, completion: nil)
                                                                            }
                                                                        }
                                                                        task.resume()
                                                                    }))
                                                                    alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler:{ action in
                                                                        self.searching = false
                                                                    }))
                                                                    self.present(alertController, animated: true, completion: nil)
                                                                }
                                                            }
                                                        }
                                                    }
                                                } else {
                                                    self.searching = false
                                                }
                                            }
                                        } catch {
                                            print("error")
                                        }
                                    })
                                    task.resume()
                                } else {
                                    var request = URLRequest(url: URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn! + "&key=AIzaSyCidOJdqXesqJzB_VMyXJtjTbAA1XiVkvY")!)
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
                                            if let dictionary = json as? [String: Any] {
                                                // Creates an array of the returned terms.
                                                if let items = dictionary["items"] as? [Any] {
                                                    // Creates a dictionary of the current term details (e.g. term, definition, term number).
                                                    if let nestedDict = items[0] as? [String: Any] {
                                                        if let volumeInfo = nestedDict["volumeInfo"] as? [String: Any] {
                                                            // Looks up the term and saves it into the variable 'term'.
                                                            if let title = volumeInfo["title"] as? String {
                                                                if let authors = volumeInfo["authors"] as? [String] {
                                                                    var combinedAuthors = ""
                                                                    for (index, author) in authors.enumerated() {
                                                                        if (index == 0) {
                                                                            combinedAuthors += author
                                                                        } else {
                                                                            combinedAuthors = combinedAuthors + " and " + author
                                                                        }
                                                                    }
                                                                    let alertController = UIAlertController(title: title, message: combinedAuthors, preferredStyle: .alert)
                                                                    alertController.addTextField { (textField) in
                                                                        textField.placeholder = "Enter book quantity"
                                                                    }
                                                                    alertController.addAction(UIAlertAction(title: "Add", style: .cancel, handler:{ action in
                                                                        if let quantity = Int((alertController.textFields?[0].text)!) {
                                                                            let url = URL(string: "http://52.22.1.14:3000/library/api/v1/books")!
                                                                            var request = URLRequest(url: url)
                                                                            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                                                                            request.httpMethod = "POST"
                                                                            let postString = "title=\(title)&author=\(authors)&quantity=\(quantity)&isbn=\(isbn!)&key=bsvr9N5wrGJVDz98UvBMnGt8"
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
                                                                                    let alertController = UIAlertController(title: "Book Added", message: "You have successfully added the book \(title) by \(combinedAuthors) to the library.", preferredStyle: .alert)
                                                                                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                                                                                        self.searching = false
                                                                                    }))
                                                                                    self.present(alertController, animated: true, completion: nil)
                                                                                } else {
                                                                                    let alertController = UIAlertController(title: "Error", message: responseString, preferredStyle: .alert)
                                                                                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                                                                                        self.searching = false
                                                                                    }))
                                                                                    self.present(alertController, animated: true, completion: nil)
                                                                                }
                                                                            }
                                                                            task.resume()
                                                                        }
                                                                    }))
                                                                    alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler:{ action in
                                                                        self.searching = false
                                                                    }))
                                                                    self.present(alertController, animated: true, completion: nil)
                                                                } else {
                                                                    let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                                                                    if let quantity = Int((alertController.textFields?[0].text)!) {
                                                                        alertController.addAction(UIAlertAction(title: "Add", style: .cancel, handler:{ action in
                                                                            let url = URL(string: "http://52.22.1.14:3000/library/api/v1/books")!
                                                                            var request = URLRequest(url: url)
                                                                            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                                                                            request.httpMethod = "POST"
                                                                            let postString = "title=\(title)&author=None&quantity=\(quantity)&isbn=\(isbn!)&key=bsvr9N5wrGJVDz98UvBMnGt8"
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
                                                                                    let alertController = UIAlertController(title: "Book Added", message: "You have added the book \(title) to the library.", preferredStyle: .alert)
                                                                                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                                                                                        self.searching = false
                                                                                    }))
                                                                                    self.present(alertController, animated: true, completion: nil)
                                                                                } else {
                                                                                    let alertController = UIAlertController(title: "Error", message: responseString, preferredStyle: .alert)
                                                                                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                                                                                        self.searching = false
                                                                                    }))
                                                                                    self.present(alertController, animated: true, completion: nil)
                                                                                }
                                                                            }
                                                                            task.resume()
                                                                        }))
                                                                    }
                                                                    alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler:{ action in
                                                                        self.searching = false
                                                                    }))
                                                                    self.present(alertController, animated: true, completion: nil)
                                                                }
                                                            }
                                                        }
                                                    }
                                                } else {
                                                    self.searching = false
                                                }
                                            }
                                        } catch {
                                            print("error")
                                        }
                                    })
                                    task.resume()
                                }
                            }
                        }
                    } catch {
                        print("error")
                    }
                })
                task1.resume()
            }
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

