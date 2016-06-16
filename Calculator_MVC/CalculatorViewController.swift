//
//  ViewController.swift
//  Calculator_MVC
//
//  Created by LiXT on 4/10/16.
//  Copyright © 2016 LiXT. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var operationLog: UILabel!
    
    var isTheFirstDigit = true
    
    var canDecimalPointBeAppended = true
    
    var isError = false
    
    var calculator = CalculatorModel()
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            isTheFirstDigit = true
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        if !isError {
            let digit = sender.currentTitle
            if isTheFirstDigit {
                display.text = digit
                isTheFirstDigit = false
            }
            else {
                display.text = display.text! + digit!
            }
        }
    }
    
    
    @IBAction func appendDecimalPoint() {
        if !isError {
            if canDecimalPointBeAppended {
                if isTheFirstDigit {
                    display.text = "0."
                    canDecimalPointBeAppended = false
                    isTheFirstDigit = false
                }
                else {
                    display.text = display.text! + "."
                    canDecimalPointBeAppended = false
                }
            }
        }
    }
    
    @IBAction func pressEnter() {
        if !isError {
            operationLog.text = operationLog.text! + "\(displayValue) " + "⏎ "
            enter()
        }
    }
    
    func enter() {
        if !isError {
            calculator.pushOperand(displayValue)
            isTheFirstDigit = true
            canDecimalPointBeAppended = true
            print("hello\n\n")
        }
    }
    
    @IBAction func pushOperation(sender: UIButton) {
        if !isError {
            if !isTheFirstDigit {
                operationLog.text = operationLog.text! + "\(displayValue) "
                enter()
            }
            let operation = sender.currentTitle
            operationLog.text = operationLog.text! + "\(operation!) "
            let result = calculator.performOperation(operation!)
            if result == nil {
                displayValue = 0
                display.text = "ERROR"
                isError = true
            }
            else {
                displayValue = result!
            }
        }
    }
    
    @IBAction func clear() {
        calculator.clear()
        isTheFirstDigit = true
        isError = false
        displayValue = 0
        operationLog.text = " "
    }

}

