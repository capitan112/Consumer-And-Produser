//
//  ViewController.swift
//  ConsumerAndProduserMultithreding
//
//  Created by Oleksiy Chebotarov on 03/11/2022.
//

import UIKit

class ViewController: UIViewController {
    private var buffer = Stack<Int>()
    private let produceQueue = DispatchQueue(label: "com.queue.produceQueue", qos: .userInitiated, attributes: .concurrent)
    private let consumeQueue = DispatchQueue(label: "com.queue.consumeQueue", qos: .userInitiated, attributes: .concurrent)
    
    private let emptySemaphore = DispatchSemaphore(value: 0)
    private let fullSemaphore = DispatchSemaphore(value: 3)
    private let mutex = Mutex()
    
    private let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
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
        
        let animationSemaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.animationView.produce(element: producer.element) {
                animationSemaphore.signal()
            }
        }
        
        animationSemaphore.wait()
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
        
        let animationSemaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.main.async {
            self.animationView.consume {
                animationSemaphore.signal()
            }
        }
        
        animationSemaphore.wait()
        mutex.unlock()
        fullSemaphore.signal()
    }
}

extension Thread {
    class func printCurrent() {
        print("\r⚡️: \(Thread.current)\r")
    }
}
