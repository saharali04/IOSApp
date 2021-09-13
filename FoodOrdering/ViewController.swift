//
//  ViewController.swift
//  FoodOrdering
//
//  Created by Sahar Ali on 9/9/21.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, LoginButtonDelegate {
    
    @IBOutlet weak var restaurantLbl: UILabel!
    @IBOutlet weak var tipTxt: UITextField!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var foodSelectionTxtField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    let foodItems = ["Cheeseburger - $6.00","Fries - $3.00","Queso - $5.00","Milkshake - $3.00","Wings - $8.00","Pizza - $12.00"]
    
    let food = ["Cheeseburger ": 6.00, "Fries ": 3.00, "Queso ": 5.00,"Milkshake ": 3.00,"Wings ": 8.00,"Pizza ": 12.00]
    
    var foodItemsToBuy = [String: Array<Double>]()
    
    var pickerView = UIPickerView()
     
    var totalPrice : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceLbl.text = ""
        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        foodSelectionTxtField.inputView = pickerView
        foodSelectionTxtField.textAlignment = .center
        foodSelectionTxtField.placeholder = "Select Food Item"
        tableView.delegate = self
        tableView.dataSource = self
        
        if let token = AccessToken.current, !token.isExpired {
                // User is logged in, do work such as go to next view controller.
            let token = token.tokenString
            
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                     parameters: ["fields": "email, name"],
                                                     tokenString: token,
                                                     version: nil,
                                                     httpMethod: .get)
            request.start(completionHandler: { connection, result, error in
                print("\(result)")
                guard let json = result as? NSDictionary else { return }
                if let name = json["name"] as? String {
                    self.restaurantLbl.text = "Hi, " + name
                } else {
                    self.restaurantLbl.text = "Hi!"
                }
            })
            
        } else {
            let loginButton = FBLoginButton()
            let newCenter = CGPoint(x: 205,y: 680)
            loginButton.center = newCenter
            loginButton.delegate = self
            loginButton.permissions = ["public_profile", "email"]
            view.addSubview(loginButton)
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                 parameters: ["fields": "email, name"],
                                                 tokenString: token,
                                                 version: nil,
                                                 httpMethod: .get)
        request.start(completionHandler: { connection, result, error in
            print("\(result)")
            guard let json = result as? NSDictionary else { return }
            if let name = json["name"] as? String {
                self.restaurantLbl.text = "Hi, " + name
            } else {
                self.restaurantLbl.text = "Hi"
            }
        })
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("hi")
        restaurantLbl.text = "GT Dining"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return foodItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return foodItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        foodSelectionTxtField.text = foodItems[row]
        foodSelectionTxtField.resignFirstResponder()
    }
    
    @IBAction func buyItems(_ sender: Any) {
        totalPrice = 0.0
        let tip = Double(tipTxt.text ?? "0.0")
        for item in foodItemsToBuy {
            totalPrice += item.value.first! * Double(item.value.last!)
            print(totalPrice)
        }
        totalPrice += tip ?? 0.0
        totalPriceLbl.text = "$\(totalPrice)"
        
    }
    
    @IBAction func addToCart(_ sender: Any) {
        if (foodSelectionTxtField.hasText) {
            let dashIndex = (foodSelectionTxtField.text?.firstIndex(of: " "))!
            let foodItem = String((foodSelectionTxtField.text?[...dashIndex])!)
            for item in food {
                if foodItem == item.key {
                    if (foodItemsToBuy[item.key] == nil ) {
                        foodItemsToBuy[item.key] = [item.value, 1]
                    } else {
                        foodItemsToBuy[item.key] = [item.value, (foodItemsToBuy[item.key]?.last!)! + 1]
                    }
                    
                }
            }
            print(foodItemsToBuy)
        } else {
            print("false")
        }
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItemsToBuy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let arrayOfFoodItems = Array(foodItemsToBuy.keys)
        let arrayOfQuantities = Array(foodItemsToBuy.values)
        cell.textLabel?.text = String(arrayOfFoodItems[indexPath.row]).padding(toLength: 25, withPad: "  ", startingAt: 0) +  String(arrayOfQuantities[indexPath.row].last ?? 1.0)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

