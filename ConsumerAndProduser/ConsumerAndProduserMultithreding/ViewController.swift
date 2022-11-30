//
//  ViewController.swift
//  ConsumerAndProduserMultithreding
//
//  Created by Oleksiy Chebotarov on 03/11/2022.
//

import UIKit

class ViewController: UIViewController {
    private var buffer = Stack<Int>()
    let groupTask = DispatchGroup()
    private let produceQueue = DispatchQueue(label: "com.queue.produceQueue", qos: .userInitiated, attributes: .concurrent)
    private let consumeQueue = DispatchQueue(label: "com.queue.consumeQueue", qos: .userInitiated, attributes: .concurrent)

    private let emptySemaphore = DispatchSemaphore(value: 0)
    private let fullSemaphore = DispatchSemaphore(value: 3)
    private let mutex = Mutex()

    override func viewDidLoad() {
        super.viewDidLoad()
        work()
    }

    func work() {
        produceQueue.async {
            for index in 1 ..< 20 {
                let producer = Producer(element: index)
                self.produce(producer: producer)
            }
        }

        consumeQueue.async {
            for _ in 0 ..< 20 {
                let consumer = Consumer()
                self.consume(consumer: consumer)
                print("ObjectIdentifier consumeQueue: \(ObjectIdentifier(self.consumeQueue))")
            }
        }
    }

    func produce(producer: Producer) {
        fullSemaphore.wait()
        mutex.lock()
        producer.putData(buffer: &buffer)
        print(buffer.description)
        print("ObjectIdentifier produceQueue: \(ObjectIdentifier(produceQueue))")
        Thread.printCurrent()
        mutex.unlock()
        emptySemaphore.signal()
    }

    func consume(consumer: Consumer) {
        emptySemaphore.wait()
        mutex.lock()
        sleep(1)
        consumer.getData(buffer: &buffer)
        print("ObjectIdentifier consumeQueue: \(ObjectIdentifier(consumeQueue))")
        Thread.printCurrent()
        print(buffer.description)
        mutex.unlock()
        fullSemaphore.signal()
    }
}

extension Thread {
    class func printCurrent() {
        print("\r⚡️: \(Thread.current)\r")
    }
}
