//
//  ViewController.swift
//  FoodOrdering
//
//  Created by Sahar Ali on 9/9/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var restaurantLbl: UILabel!
    @IBOutlet weak var tipTxt: UITextField!
    @IBOutlet weak var totalPriceLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceLbl.text = ""
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buyItems(_ sender: Any) {
        let tip = Double(tipTxt.text!)!
        let totalPrice = tip + 15.00
        totalPriceLbl.text = "$\(totalPrice)"
        
    }
}

