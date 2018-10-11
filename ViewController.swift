//
//  ViewController.swift
//  Bitcoin Price Tracker
//
//  Created by Prateek Katyal on 10/10/18.
//  Copyright © 2018 Prateek Katyal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usdLabel: UILabel!
    
    @IBOutlet weak var jpyLabel: UILabel!
    
    @IBOutlet weak var eurLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        // Calling the default price function to set user default
        
        getDefaultPrices()
        
        // Calling our main getprice funciton on viewdidload
        
        getPrice()
        
    }
    
    
    // Setting up a funciton to get default prices for labels when app loads
    
    func getDefaultPrices() {
        
        let usdPrice = UserDefaults.standard.double(forKey: "USD")
        if usdPrice != 0.0 {
            self.usdLabel.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "USD") + "~"
        }
        
        let jpyPrice = UserDefaults.standard.double(forKey: "JPY")
        if jpyPrice != 0.0 {
            self.jpyLabel.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "JPY") + "~"
        }
        
        let eurPrice = UserDefaults.standard.double(forKey: "EUR")
        if eurPrice != 0.0 {
            self.eurLabel.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "EUR") + "~"
        }
        
        
    }
    
    
    // Function to Get the bitcoin price
    
    func getPrice() {
        
        // Passing the URL where we want it to go
        
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,JPY,EUR") {
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let data = data {
                    
                    // Creating our JSON Object to GET USD price
                    
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Double] {
                        
                        if let jsonDictionary = json {
                            
                            // Get back into the main thread
                            
                            DispatchQueue.main.async {
                                
                                
                                if let usdPrice = jsonDictionary["USD"] {
                                    
                                    
                                    
                                    self.usdLabel.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "USD")
                                    
                                    // Saving User Defaults
                                    
                                    UserDefaults.standard.set(usdPrice, forKey: "USD")
                                    
                                    
                                }
                            }
                        }
                        
                    }
                    
                    // Creating our JSON Object to GET JPY price
                    
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Double] {
                        
                        if let jsonDictionary = json {
                            
                            // Get back into the main thread
                            
                            DispatchQueue.main.async {
                                
                                
                                if let jpyPrice = jsonDictionary["JPY"] {
                                    self.jpyLabel.text = self.doubleToMoneyString(price: jpyPrice, currencyCode: "JPY")
                                    
                                    // Saving User Defaults
                                    
                                    UserDefaults.standard.set(jpyPrice, forKey: "JPY")
                                    
                                    
                                }
                            }
                        }
                        
                    }
                    
                    
                    // Creating our JSON Object to GET EUR price
                    
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Double] {
                        
                        if let jsonDictionary = json {
                            
                            // Get back into the main thread
                            
                            DispatchQueue.main.async {
                                
                                
                                if let eurPrice = jsonDictionary["EUR"] {
                                    self.eurLabel.text = self.doubleToMoneyString(price: eurPrice, currencyCode: "EUR")
                                    
                                    // Saving User Defaults
                                    
                                    UserDefaults.standard.set(eurPrice, forKey: "EUR")
                                    
                                    
                                }
                                
                                // Saving User Defaults
                                
                                UserDefaults.standard.synchronize()
                                
                            }
                        }
                        
                    }
                    
                    
                } else {
                    print("Something went wrong.")
                }
                
                }.resume()
            
        }
    }
    
    func doubleToMoneyString(price: Double, currencyCode: String) -> String {
        
        // Adding the number formatter
        
        let formatter = NumberFormatter()
        // Telling the formatter we are working with currency
        
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        
        let priceString = formatter.string(from: NSNumber(value: price))
        
        if priceString == nil {
            return "Error"
        } else {
             return priceString!
        }
        
       
        
        
    }
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        
        // Just call the function getPrice to refresh stuff!
        
        getPrice()
        
    }
    
    
}

