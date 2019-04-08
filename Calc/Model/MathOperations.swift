//
//  MathOperations.swift
//  Calc
//
//  Created by Piotr Glaza on 30/03/2019.
//  Copyright © 2019 Piotr Glaza. All rights reserved.
//

import Foundation

enum currentOperation: String, CustomStringConvertible{
    case Plus , Minus, Multiply, Divide, None
    
    var description: String {
        switch self {
        case .Plus: return " + "
        case .Minus: return " - "
        case .Multiply: return " * "
        case .Divide: return " / "
        case .None: return ""
        }
    }
}

struct MathOperations {
    
    // expresions is like ValueA + ValueB = result
    
    var valueA: Double = 0
    var valueB: Double = 0
    var result: Double = 0 {
        willSet {
            valueA = result
            print("VAlueA is set")
        }
    }
    
    // this boolean is for reapeting result if "=" has been pressed more than once
    var equalOperationPerformed: Bool = false
    var anyMathOperationPerformed: Bool = false
    var currentMathOperation: currentOperation = .None
    
    
    init() {
        
    }
    
    mutating func performMathOperation(valueFromDisplay: String, operation:	(Double, Double) -> Double)  -> Double {
        
        // checks if = was pressed already or any other operations like +,- was performed.
        if equalOperationPerformed == false || anyMathOperationPerformed == true {
               valueB = (valueFromDisplay as NSString).doubleValue
            equalOperationPerformed = true
        }
      
        print("Value A is \(valueA) and valueB is \(valueB)")
       
        return operation(valueA, valueB)
    }
    
    
    
    mutating func performPercentageOperation(valueFromMainDisplay: String) ->Double {
        
        var result: Double?
        
        if (valueA == 0) {
            result = ((valueFromMainDisplay as NSString).doubleValue) / 100
        } else {
            result = ((valueA * (valueFromMainDisplay as NSString).doubleValue) / 100)
        }
          return result!
    }
    
    mutating func reset() {
        
        valueA = 0
        valueB = 0
        equalOperationPerformed = false
        currentMathOperation = .None
        
    }
}

