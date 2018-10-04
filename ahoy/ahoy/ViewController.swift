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
        }
        
        city = (location.text?.lowercased())!
        
        location.text?.removeAll()
        
        
        // Create URL from user inpuyt
        
        if let url = URL(string: "http://www.bom.gov.au/\(state)/forecasts/\(city).shtml?ref=hdr") {
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    self.summary.text = "Error Occured"
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
//                        print(dataString!)
                        
                        
                        DispatchQueue.main.async {
                            if dataString!.contains("area") {
                                
                                let range = dataString!.range(of: "area</h3>")
                                
                                let rangeEnd = dataString!.range(of: "<p class=\"alert\">")
                                
//                                print(dataString)
                                
                                print(rangeEnd)
//                                print(dataString!.substring(with: NSRange(location: rangeEnd.location, length: 31)))
                                
                                
                               self.summary.text = NSString(string: dataString!.substring(from: range.location + 17)).substring(to: rangeEnd.location - (range.location + 33))
                                
//                                self.summary.text = dataString!.substring(with: NSRange(location: range.location + 31, length: rangeEnd.location - 9))
//                                self.summary.text = "Found"
                                
                                
                            }else {
                                self.summary.text = "City not found. Please try again!"
                            }
                        }
                        
//                        if self.testData.contains("html") {
//                            summary.text = "Found Day"
//                        }
                    }
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

