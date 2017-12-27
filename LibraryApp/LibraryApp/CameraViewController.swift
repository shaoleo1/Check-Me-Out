//
//  CameraViewController.swift
//  LibraryApp
//
//  Created by Vicky Zheng on 12/19/17.
//  Copyright © 2017 Vicky Zheng. All rights reserved.
//

import UIKit
import AVFoundation

//extends UIView and specifies that the view will be backed by AVCaptureVideoPreviewLayer
class CameraView: UIView {
    
    var scanned = false
    
    override class var layerClass: AnyClass {
        get {
            return AVCaptureVideoPreviewLayer.self
        }
    }
    
    override var layer: AVCaptureVideoPreviewLayer {
        get {
            return super.layer as! AVCaptureVideoPreviewLayer
        }
    }
}

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
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
            
            var request = URLRequest(url: URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn!)!)
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
                                        let alertController = UIAlertController(title: title, message: isbn, preferredStyle: .alert)
                                        alertController.addAction(UIAlertAction(title: "Check Out", style: .default, handler:nil))
                                        
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
