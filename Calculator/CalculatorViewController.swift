//
//  ViewController.swift
//  Calculator
//
//  Created by Jessica Gillan on 3/17/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyDisplay: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()
    
    var displayValue: Double? {
        get{
            if let doubleValue = NSNumberFormatter().numberFromString(display.text!)?.doubleValue{
                return doubleValue
            } else {
                return nil
            }
        }
        set{
            if let newDoubleValue = newValue { //newValue is magic variable inside set, if user put displayValue = 5, then newValue would have 5. then onverting to string and setting display text
                display.text = "\(newDoubleValue)"
            } else {
                // Setting displayValue to nil clears the display, should it also affect history, opStack, etc ??
                display.text = " "
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }

    // MARK: Actions
    
    // This function with ignoring multiple decimal points and adding a zero to leading "." could be cleaned up now that displayValue
    // is an optional? Try to redo this in less code
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            if digit == "." && display.text!.rangeOfString(digit) != nil {
                // Ignore multiple decimal points
            } else{
                display.text = display.text! + digit
            }
        } else {
            if digit == "." {
                display.text = "0" + digit
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTypingANumber = true
        }
        print("digit = \(digit)")
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let operand = displayValue {
            if let result = brain.pushOperand(operand){
                displayValue = result
                historyDisplay.text = brain.description
            } else {
                displayValue = nil
            }
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        displayValue = brain.clear()
        historyDisplay.text = brain.description
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber { enter() }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            } else {
                displayValue = nil
            }
            historyDisplay.text = brain.description
        }
        // No else here, so if button is tied to func operate and does not have a title = nothing happens? Is this desired result?
    }
    
    @IBAction func SetVariableValue() {
        userIsInTheMiddleOfTypingANumber = false
        if let variableValue = displayValue {
            brain.variableValues[ "M" ] = variableValue
        }
        if let result = brain.evaluate() {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func pushVariable(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber { enter() }
        if let variable = sender.currentTitle {
            if let result = brain.pushVariableOperand(variable) {
                displayValue = result
            } else {
                displayValue = nil
            }
            historyDisplay.text = brain.description
        }
    }
    
 }

