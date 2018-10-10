//
//  ViewController.swift
//  ahoy
//
//  Created by Sash Petrovski on 2/10/18.
//  Copyright © 2018 Bamello. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var summary: UILabel!
    
    var state: String = ""
    var city: String = ""
    
    
    @IBAction func submit(_ sender: Any) {
        summary.text = "Loading"
        
        if location.text?.lowercased() == "sydney" {
            state = "nsw"
            
        } else if location.text?.lowercased() == "melbourne" {
            state = "vic"
        } else if location.text?.lowercased() == "brisbane" {
            state = "qld"
        } else if location.text?.lowercased() == "perth" {
            state = "wa"
        } else if location.text?.lowercased() == "adelaide" {
            state = "sa"
        } else if location.text?.lowercased() == "hobart" {
            state = "tas"
        } else if location.text?.lowercased() == "canberra" {
            state = "act"
        } else if location.text?.lowercased() == "darwin" {
            state = "nt"
        } else {
            state = "NA"
        }
        
        city = (location.text?.lowercased())!
        
        location.text?.removeAll()
        
        
        // Create URL from user inpuyt
        
        if let url = URL(string: "http://www.bom.gov.au/\(state)/forecasts/\(city).shtml?ref=hdr") {
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                var message = ""
                
                if error != nil {
                    self.summary.text = "Error Occured"
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)

                        var stringSeparator = """
 area</h3>
    <p>
"""
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
//                            if dataString!.contains("The page you requested was not found on this server") {
//                                message = ""
//                            }
//                            else {
                            if contentArray.count > 1 {
                                stringSeparator = "</p>"

                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)

                                if newContentArray.count > 1 {
                                    message = newContentArray[0]

                                    print(contentArray[1])
                                }
                            }
                        }
                    }
                }
                if message == "" {
                    message = "The weather there couldn't be found. Please try again?"
                    
                }
                DispatchQueue.main.sync {
                    self.summary.text = message
                }
            }
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Hide keyboard when text field is not in focus
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    // Hide keyboard when hit return on virtual keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }

}

