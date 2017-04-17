//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jared Owens on 3/4/17.
//

import Foundation

func changeSign(operand: Double) -> Double
{
    return -operand
}

//structs do not have inheritance
//Classes live in the heap, with pointers, reference types. Stucts are passed by copying, value types
//Pick struct because you only see the controller accessing it as opposed to several  other things asking for it
struct CalculatorBrian {
    
    private var accumulator: Double?
    
    private enum Operation
    {
        //assosciated value for enum
        case constant (Double)
        //function that takes a double and returns a double
        case unaryOperation ((Double) -> Double)
        case binaryOperation ((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> =
        [
            "π" : Operation.constant(Double.pi),
            "e" : Operation.constant(M_E),
            "√" : Operation.unaryOperation(sqrt),
            "cos" : Operation.unaryOperation(cos),
            "cos" : Operation.unaryOperation(sin),
            "cos" : Operation.unaryOperation(tan),
            "±" : Operation.unaryOperation({ -$0 }),
            "+" : Operation.binaryOperation({ $0 + $1 }),
            "−" : Operation.binaryOperation({ $0 - $1 }),
            "×" : Operation.binaryOperation({ $0 * $1 }),
            "÷" : Operation.binaryOperation({ $0 / $1 }),
            "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol]
        {
            switch operation {
            case.constant(let value):
                accumulator = value
            case.unaryOperation(let function):
                if accumulator != nil
                {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation (let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    //mutating because it is changing the accumulator
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            
            //not in middle of binary operation
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
