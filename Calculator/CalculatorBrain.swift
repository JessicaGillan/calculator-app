//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jessica Gillan on 4/8/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: CustomStringConvertible { // The enum is NOT inheriting, CustomStringConvertible is a protocol, which in this case is single computed var
        case Operand(Double)
        case Constant(String, Double)
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String { // How to make any type in to string
            switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .Constant(let symbol, _):
                    return "\(symbol)"
                case .Variable(let variable):
                    return variable
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]() //Dictionary with String keys and Op values, need to initialize when a CalculatorBrain is created
    
    var variableValues = [String:Double]() //Allow user to push variables and associated value
    
    init(){
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        learnOp( Op.BinaryOperation("x", *) )           // Needs string and func that takes 2 args -> dble = * 
                                                        // (special props allow this function to be written inline
        learnOp( Op.BinaryOperation("/") { $1 / $0 } )  // Can't do it w/divide and minus since order is backward
        learnOp( Op.BinaryOperation("+", +) )
        learnOp( Op.BinaryOperation("-") { $1 - $0 } )
        learnOp( Op.UnaryOperation("√", sqrt) )         // Needs to be a function that takes Double and returns Double, can be named!
        learnOp( Op.UnaryOperation("sin", sin) )
        learnOp( Op.UnaryOperation("cos", cos) )
        learnOp( Op.Constant("π", M_PI) )
    }
    
    // Computed Variable
    var description: String {
        get{
            var variableInStack = false
            func evaluateDescription(ops: [Op]) -> (result: String, remainingOps: [Op]){
                if !ops.isEmpty {
                    var remainingOps = ops
                    let op = remainingOps.removeLast()
                    switch op {
                        case .Operand: // It's really Op.Operand but can use type inference to start with "."
                            return( op.description, remainingOps )
                        case .Constant:
                            return( op.description, remainingOps )
                        case .Variable:
                            variableInStack = true
                            return( op.description, remainingOps )
                        case .UnaryOperation:
                            let operandDescription = evaluateDescription(remainingOps)
                            let operandEvaluation = evaluate(remainingOps)
                            if operandEvaluation.result != nil || variableInStack {
                                return(op.description + "(" + operandDescription.result + ")", operandDescription.remainingOps)
                            } else {
                                return(op.description + "?", operandEvaluation.remainingOps)
                            }
                        case .BinaryOperation:
                            let op1Description = evaluateDescription(remainingOps)
                            let op1Evaluation = evaluate(remainingOps)
                            if op1Evaluation.result != nil || variableInStack {
                                let op2Description = evaluateDescription(op1Description.remainingOps)
                                let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                                if op2Evaluation.result != nil || variableInStack {
                                        return(op2Description.result + op.description + "(" + op1Description.result + ")", op2Description.remainingOps)
                                } else {
                                    return("?" + op.description + "(" + op1Description.result + ")", op2Description.remainingOps)
                                }
                            } else {
                                return("?" + op.description + "?", op1Description.remainingOps)
                            }
                    }
                }
                // Default case = ops is Empty
                return(" ", ops)
            }
            
            var (fullResult, remainder) = evaluateDescription(opStack)
            while(!remainder.isEmpty){
                let evaluation = evaluateDescription(remainder)
                fullResult = evaluation.result + ", " + fullResult
                remainder = evaluation.remainingOps
            }
            print("Description = " + fullResult)
            if fullResult == " " {
                return fullResult
            } else {
                return fullResult + " ="
            }
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
                case .Operand( let operand ): // It's really Op.Operand but can use type inference to start with "."
                    return(operand, remainingOps)
                case .Constant( _, let constant ):
                    return( constant, remainingOps )
                case .Variable( let variable ):
                    if let value = variableValues[variable] {
                        return( value, remainingOps )
                    }
                case .UnaryOperation(_, let operation):
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        return( operation(operand), operandEvaluation.remainingOps )
                    }
                case .BinaryOperation(_, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let op1 = op1Evaluation.result {
                        let op2Evaluation = evaluate( op1Evaluation.remainingOps )
                        if let op2 = op2Evaluation.result {
                            return( operation(op1, op2), op2Evaluation.remainingOps )
                        }
                    }
            }
            
        }
        return(nil, ops) // Failure/Default case
    }
    
    func evaluate() -> Double? { // Needs to return optional since user could hit evaluate w/o entering operands etc
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
   func pushVariableOperand(symbol: String) -> Double? {
        opStack.append( Op.Variable(symbol) )
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear() -> Double? {
        opStack = [Op]()
        variableValues = [String:Double]()
        return nil
    }
    
}