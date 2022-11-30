//
//  Stack.swift
//  ConsumerAndProduserMultithreding
//
//  Created by Oleksiy Chebotarov on 03/11/2022.
//

import Foundation

class Stack<T>: CustomStringConvertible {
    
    private var elements: [T] = []
    
    func push(_ element: T) {
        elements.append(element)
    }
    
    func pop() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.popLast()
    }
    
    var top: T? {
        return elements.last
    }
    
    var description: String {
        return "---- Stack begin ----\n" +
            elements.map({ "\($0)" }).joined (separator: "\n") +
            "\n----  Stack End ----"
    }
}
