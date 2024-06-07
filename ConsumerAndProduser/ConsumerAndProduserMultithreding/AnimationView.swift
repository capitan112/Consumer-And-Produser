//
//  AnimationView.swift
//  ConsumerAndProduserMultithreding
//
//  Created by Oleksiy Chebotarov on 07/06/2024.
//

import Foundation
import UIKit


class AnimationView: UIView {
    private var bufferStack: [UIView] = []
    private let stackView = UIStackView()
    
    private let producerView = UIView()
    private let consumerView = UIView()
    
    private let producerColor = UIColor.green
    private let consumerColor = UIColor.red
    private let bufferColor = UIColor.blue
    private let clearColor = UIColor.clear
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        setupProducerView()
        setupConsumerView()
        setupStackView()
        setupLabels()
    }
    
    private func setupProducerView() {
        producerView.backgroundColor = producerColor
        producerView.layer.cornerRadius = 5
        addSubview(producerView)
        
        producerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            producerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            producerView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            producerView.widthAnchor.constraint(equalToConstant: 50),
            producerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupConsumerView() {
        consumerView.backgroundColor = consumerColor
        consumerView.layer.cornerRadius = 5
        addSubview(consumerView)
        
        consumerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            consumerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            consumerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            consumerView.widthAnchor.constraint(equalToConstant: 50),
            consumerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 50),
            stackView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        for _ in 0..<3 {
            let clearView = createClearView()
            stackView.addArrangedSubview(clearView)
        }
    }
    
    private func setupLabels() {
        let producerLabel = createLabel(text: "Producer")
        addSubview(producerLabel)
        NSLayoutConstraint.activate([
            producerLabel.centerXAnchor.constraint(equalTo: producerView.centerXAnchor),
            producerLabel.topAnchor.constraint(equalTo: producerView.bottomAnchor, constant: 10)
        ])
        
        let consumerLabel = createLabel(text: "Consumer")
        addSubview(consumerLabel)
        NSLayoutConstraint.activate([
            consumerLabel.centerXAnchor.constraint(equalTo: consumerView.centerXAnchor),
            consumerLabel.bottomAnchor.constraint(equalTo: consumerView.topAnchor, constant: -10)
        ])
        
        let bufferLabel = createLabel(text: "Buffer")
        addSubview(bufferLabel)
        NSLayoutConstraint.activate([
            bufferLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            bufferLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10)
        ])
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func produce(element: Int, completion: @escaping () -> Void) {
        let elementView = createElementView(text: "\(element)", color: bufferColor)
         
        let producerCenter = self.convert(producerView.center, from: producerView.superview)
        elementView.alpha = 0.0
        elementView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.addSubview(elementView)
        
        let destinationCenter = self.convert(stackView.center, from: stackView.superview)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.5, animations: {
                elementView.center = producerCenter
                elementView.alpha = 1.0
                elementView.transform = CGAffineTransform.identity
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                    elementView.center = destinationCenter
                }, completion: { _ in
                    
                    if let firstClearView = self.stackView.arrangedSubviews.first(where: { $0.backgroundColor == self.clearColor }) {
                        if let index = self.stackView.arrangedSubviews.firstIndex(of: firstClearView) {
                            self.stackView.removeArrangedSubview(firstClearView)
                            firstClearView.removeFromSuperview()
                            self.stackView.insertArrangedSubview(elementView, at: index)
                        }
                    }
                    self.bufferStack.append(elementView)
                    completion()
                })
            })
        }
    }
    
    func consume(completion: @escaping () -> Void) {
        guard let lastElementView = bufferStack.popLast() else {
            completion()
            return
        }

        let destinationCenter = self.convert(consumerView.center, from: consumerView.superview)
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
            lastElementView.center = destinationCenter

        }, completion: { _ in
            if let index = self.stackView.arrangedSubviews.firstIndex(of: lastElementView) {
                self.stackView.removeArrangedSubview(lastElementView)
                lastElementView.removeFromSuperview()
                let clearView = self.createClearView()
                self.stackView.insertArrangedSubview(clearView, at: index)
            }
            completion()
        })
    }
    
    private func createElementView(text: String, color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 50),
            view.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        addSubview(view)
        
        return view
    }
    
    private func createClearView() -> UIView {
        let view = UIView()
        view.backgroundColor = clearColor
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 50),
            view.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return view
    }
}

