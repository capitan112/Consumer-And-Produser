//
//  Consumer.swift
//  ConsumerAndProduserMultithreding
//
//  Created by Oleksiy Chebotarov on 30/11/2022.
//

import Foundation

class Consumer {
    func getData(buffer: inout Stack<Int>) {
        if let element = buffer.pop() {
            print("element was taken: \(String(describing: element))")
        } else {
            print("element was taken nil")
        }
    }
}
