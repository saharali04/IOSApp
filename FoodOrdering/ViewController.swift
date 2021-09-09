//
//  ViewController.swift
//  FoodOrdering
//
//  Created by Sahar Ali on 9/9/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var restaurantLbl: UILabel!
    @IBOutlet weak var tipTxt: UITextField!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var foodSelectionTxtField: UITextField!
    
    let foodItems = ["Cheeseburger - $6.00","Fries $3.00","Chicken Tenders - $5.00","Milkshake - $3.00","Wings - $8.00","Pizza - $12.00"]
    
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceLbl.text = ""
        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        foodSelectionTxtField.inputView = pickerView
        foodSelectionTxtField.textAlignment = .center
        foodSelectionTxtField.placeholder = "Select Food Item"
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
        let tip = Double(tipTxt.text!)!
        let totalPrice = tip + 15.00
        totalPriceLbl.text = "$\(totalPrice)"
        
    }
}

