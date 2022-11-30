//
//  Producer.swift
//  ConsumerAndProduserMultithreding
//
//  Created by Oleksiy Chebotarov on 30/11/2022.
//

import Foundation

class Producer {
    let element: Int

    init(element: Int) {
        self.element = element
    }

    func putData(buffer: inout Stack<Int>) {
        print("element was pushed by Producer: \(element)")
        buffer.push(element)
    }
}
