//
//  ViewController.swift
//  Calc
//
//  Created by Piotr Glaza on 29/03/2019.
//  Copyright © 2019 Piotr Glaza. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var btnNumbers: [UIButton]!
    @IBOutlet weak var secondaryDisplay: UILabel!
    @IBOutlet weak var mainDisplay: UILabel!
    @IBOutlet weak var expressionDisplay: UILabel!
    
    
    // here in this structure all math operations will be performed
    var mathOp = MathOperations()
    var firstNumberEntered: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        expressionDisplay.lineBreakMode = .byWordWrapping
    }

    // is resposible for pushing numbers 0-9 from buttons to display
    @IBAction func numbersAction(_ sender: UIButton) {
        
        
        if mathOp.currentMathOperation != .None && firstNumberEntered == false {
            mainDisplay.text = ""
            firstNumberEntered = true
        }
        
        // block if user enter more than 8 digits
        if mainDisplay.text!.count == 8 { return }
        
        // if it's zero displayed first remove it, otherwise append another digit
        if mainDisplay.text == "0" {
            mainDisplay.text = String(sender.tag)
            secondaryDisplay.text = String(sender.tag)
        } else {
             mainDisplay.text = mainDisplay.text! + String(sender.tag)
            secondaryDisplay.text = secondaryDisplay.text! + String(sender.tag)
        }
   }
    
    @IBAction func clearOperation(_ sender: UIButton) {
       
        mainDisplay.text = "0"
        secondaryDisplay.text = "0"
        mathOp.reset()
       
    }
    
    @IBAction func mathOperations(_ sender: UIButton) {
        
        switch (sender.tag) {
        case 0:
            
          // operation is Equal. perform Math
            secondaryDisplay.text = secondaryDisplay.text! + " = "
            
            switch (mathOp.currentMathOperation) {
            case .Plus:
               
                
                mathOp.result = mathOp.performMathOperation(valueFromDisplay: mainDisplay.text!) { $0 + $1}
                
            case .Minus:
             mathOp.result = mathOp.performMathOperation(valueFromDisplay: mainDisplay.text!) { $0 - $1}
            
            case .Multiply:
                mathOp.result = mathOp.performMathOperation(valueFromDisplay: mainDisplay.text!) { $0 * $1}
                
            case .Divide:
                 mathOp.result = mathOp.performMathOperation(valueFromDisplay: mainDisplay.text!) { $0 / $1}
                
            case .None:
                return
                
                
            }
            
            pushToMainDisplay(value: mathOp.result)
            
            mathOp.anyMathOperationPerformed = false
            
            pushToSecondaryDisplay(value: mathOp.result, sign: mathOp.currentMathOperation)
         //   secondaryDisplay.text = secondaryDisplay.text! + String(mathOp.result)
          
            
    // other operations Plus,Minus, etc including double clicking (one after another) Math operation button
            
        case 1:
            
            mathOp.currentMathOperation = .Plus
          
            if mathOp.anyMathOperationPerformed == true {
                
                 mathOp.result = mathOp.performMathOperation(valueFromDisplay: mainDisplay.text!) { $0 + $1}
               
                 mathOp.valueA = mathOp.result
                 pushToMainDisplay(value: mathOp.result)
              
                
            }
            
            
            mathOp.anyMathOperationPerformed = true
            secondaryDisplay.text = secondaryDisplay.text! + mathOp.currentMathOperation.description
      
        case 2:
            mathOp.currentMathOperation = .Minus
          
            
        case 3:
            mathOp.currentMathOperation = .Multiply
           
            
        case 4:
            mathOp.currentMathOperation = .Divide
        
        default:
            mathOp.currentMathOperation = .None
       }
        
       mathOp.valueA = (mainDisplay.text! as NSString).doubleValue
        firstNumberEntered = false
      
    }
    
    @IBAction func percentageOperation(_ sender: Any) {
        
        pushToMainDisplay(value: (mathOp.performPercentageOperation(valueFromMainDisplay: mainDisplay.text!)))
     
    }
  
   
    @IBAction func plusMinusOperation(_ sender: Any) {
        if mainDisplay.text!.hasPrefix("-") {
            mainDisplay.text!.remove(at: mainDisplay.text!.startIndex)
        }
            else if
            mainDisplay.text! == "0" {
               return
        }
            else {
            mainDisplay.text!.insert("-", at: mainDisplay.text!.startIndex)
        }
    }
    
    @IBAction func dotOperation(_ sender: UIButton) {
        
        if mathOp.equalOperationPerformed == true && mathOp.anyMathOperationPerformed == false {
            return
        }
        if mainDisplay.text!.contains(".") {
            return
        } else {
            mainDisplay.text = mainDisplay.text! + "."
        }
    }
    
    func pushToMainDisplay(value: Double) {
        
      mainDisplay.text = removeUnnecessaryDotZero(value: value)
    
    }
    
    func pushNumberToSecondaryDisplay(value: Int) {
        
       secondaryDisplay.text = secondaryDisplay.text! + String(value)
        
    }
    
    func pushToSecondaryDisplay(value: Double, sign: currentOperation) {
        
        print(" \(value) and \(sign.description)")
        if secondaryDisplay.text! == "0" {
            secondaryDisplay.text = removeUnnecessaryDotZero(value: mathOp.valueA)
        } else {
            secondaryDisplay.text = secondaryDisplay.text! + removeUnnecessaryDotZero(value: mathOp.valueB)
        }
        secondaryDisplay.text = secondaryDisplay.text! + sign.description
        
    }
    
    func removeUnnecessaryDotZero(value: Double) ->String {
        
        // this line below is responsible to remove floating point if not needed like 0.0 or 12.0
        
        return (value.truncatingRemainder(dividingBy: 1) == 0 ) ? String(format: "%.0f", value) : String(value)
    }
    
    func updateBothDisplays() {
      
    
        pushToSecondaryDisplay(value: mathOp.valueB, sign: .None)
    }
    
   
}

