//
//  ViewController.swift
//  calculator
//
//  Created by ryanliu on 2017/4/17.
//  Copyright © 2017年 ryanliu. All rights reserved.
//

import UIKit
import CalculatorCore

extension Double {
    
    /// This computed property would provide a formatted string representation of this double value.
    /// For an integer value, like `2.0`, this property would be `"2"`.
    /// And for other values like `2.4`, this would be `"2.4"`.
    fileprivate var displayString: String {
        // 1. We have to check whether this double value is an integer or not.
        //    Here I subtract the value with its floor. If the result is zero, it's an integer.
        //    (Note: `floor` means removing its fraction part, 無條件捨去.
        //           `ceiling` also removes the fraction part, but it's by adding. 無條件進位.)
        let floor = self.rounded(.towardZero)  // You should check document for the `rounded` method of double
        let isInteger = self.distance(to: floor).isZero
        
        let string = String(self)
        if isInteger {
            // Okay this value is an integer, so we have to remove the `.` and tail zeros.
            // 1. Find the index of `.` first
            if let indexOfDot = string.characters.index(of: ".") {
                // 2. Return the substring from 0 to the index of dot
                //    For example: "2.0" --> "2"
                return string.substring(to: indexOfDot)
            }
        }
        // Return original string representation
        return String(self)
    }
}

class ViewController: UIViewController {
    
    var core = Core<Double>()
    var root = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var displayLabel: UILabel!
    
    @IBAction func numericButtonClicked(_ sender: UIButton) {
        let numericButtonDigit = sender.tag - 1000
        let digitText = "\(numericButtonDigit)"
   
    // Show the digit
    let currentText = self.displayLabel.text ?? "0"
    if currentText == "0" {
    // When the current display text is "0", replace it directly.
    self.displayLabel.text = digitText
    } else {
    // Else, append it
    self.displayLabel.text = currentText + digitText
    }
    }
    
    @IBAction func dotButtonClicked(_ sender: UIButton) {
        let currentText = self.displayLabel.text ?? "0"
    
        guard !currentText.contains(".") else {
            return
        }
        self.displayLabel.text = currentText + "."
    }
    @IBAction func clearButtonClicked(_ sender: UIButton) {
        self.displayLabel.text = "0"
        self.core = Core<Double>()
    }
    @IBAction func calculateButtonClicked(_ sender: UIButton) {
        let currentNumber = Double(self.displayLabel.text ?? "0")!
        if  root == true {
            try! self.core.addStep(1/currentNumber)
            self.root = false
        } else {
            try! self.core.addStep(currentNumber)
        }
        let result = self.core.calculate()!
        self.displayLabel.text = result.displayString
        self.core = Core<Double>()
    }

    @IBAction func operatorButtonClicked(_ sender: UIButton) {
        // Add current number into the core as a step
        let currentNumber = Double(self.displayLabel.text ?? "0")!
        try! self.core.addStep(currentNumber)
        // Clean the display to accept user's new input
        self.displayLabel.text = "0"
        
        // Here, I use tag to check whether the button it is.
        switch sender.tag {
        case 1101: // Add
            try! self.core.addStep(+)
        case 1102: // Sub
            try! self.core.addStep(-)
        case 1103:
            try! self.core.addStep(*)
        case 1104:
            try! self.core.addStep(/)
        case 1106:
            try! self.core.addStep(pow)
        case 1107:
            try! self.core.addStep(pow)
            self.root = true
        default:
            fatalError("Unknown operator button: \(sender)")
        }
    }
    @IBAction func 常數(_ sender: UIButton) {
        switch sender.tag {
        case 1110:
            self.displayLabel.text = "\(M_E)"
        case 1111:
            self.displayLabel.text = "\(Double.pi)"
        default:
            fatalError("Unknown operator button: \(sender)")

        }
    }
    @IBAction func log(_ sender: UIButton) {
        let currentNumber = Double(self.displayLabel.text ?? "0")!
       self.displayLabel.text = "\(log10(currentNumber))"
    }
    @IBAction func 負號(_ sender: UIButton) {
        self.displayLabel.text = "-" + self.displayLabel.text!
    }
    @IBAction func percent(_ sender: UIButton) {
        let currentNumber = Double(self.displayLabel.text ?? "0")!
        self.displayLabel.text = "\(currentNumber/100)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

