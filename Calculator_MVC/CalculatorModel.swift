//
//  CalculatorModel.swift
//  Calculator_MVC
//
//  Created by LiXT on 4/10/16.
//  Copyright © 2016 LiXT. All rights reserved.
//

import Foundation

class CalculatorModel {
    
    private var opStack = [Op]()
    
    private var knownOps = [String: Op]()
    
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String, (Double, Double)->Double)
    }
    
    init() {
        knownOps["+"] = Op.BinaryOperation("+", {$0 + $1})
        knownOps["−"] = Op.BinaryOperation("−", {$1 - $0})
        knownOps["×"] = Op.BinaryOperation("×", {$0 * $1})
        knownOps["÷"] = Op.BinaryOperation("÷", {$1 / $0})
        knownOps["√"] = Op.UnaryOperation("√", {sqrt($0)})
        knownOps["SIN"] = Op.UnaryOperation("COS", {cos($0)})
        knownOps["COS"] = Op.UnaryOperation("COS", {cos($0)})
        knownOps["TAN"] = Op.UnaryOperation("TAN", {tan($0)})
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(operationMark: String) -> Double? {
        if let operation = knownOps[operationMark] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func evaluate() -> Double? {
        print("opStack is \(opStack)\n")
        return evaluate(opStack).result
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?,  restOps: [Op]) {
        if !ops.isEmpty {
            var restOps = ops
            let op = restOps.removeLast()
            switch op {
                case .Operand(let operand):
                    return (operand, restOps)
                case .UnaryOperation(_, let operation):
                    let operandEvaluation = evaluate(restOps)
                    if let operand = operandEvaluation.result {
                        return (operation(operand), operandEvaluation.restOps)
                    }
                case .BinaryOperation(_, let operation):
                    let operand1Evaluation = evaluate(restOps)
                    if let operand1 = operand1Evaluation.result {
                        let operand2Evaluation = evaluate(operand1Evaluation.restOps)
                        if let operand2 = operand2Evaluation.result {
                            return (operation(operand1, operand2), operand2Evaluation.restOps)
                        }
                }
            }
        }
        return (nil, ops)
    }

    func clear() {
        opStack.removeAll()
    }
    
}

