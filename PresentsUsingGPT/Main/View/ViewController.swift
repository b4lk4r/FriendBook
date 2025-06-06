//
//  ViewController.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 22.05.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private let presenter: PresenterInput
    
    private let inputTextField = UITextField()
    private let sendButton = UIButton(type: .system)
    private let responseLabel = UILabel()
    
    // MARK: Init
    
    init(presenter: PresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        inputTextField.borderStyle = .roundedRect
        inputTextField.placeholder = "Введите текст запроса"
        
        sendButton.setTitle("Отправить", for: .normal)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        
        responseLabel.numberOfLines = 0
        responseLabel.textColor = .darkGray
        
        let stack = UIStackView(arrangedSubviews: [inputTextField, sendButton, responseLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])
    }
    
    @objc private func sendTapped() {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        responseLabel.text = "Отправка..."
        
        presenter.sendPrompt(text)
    }
    
//    private func sendMessage(text: String, completion: @escaping (String?) -> Void) {
//        var request = URLRequest(url: apiURL)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let jsonBody: [String: Any] = [
//            "model": "GigaChat",
//            "messages": [
//                [
//                    "role": "user",
//                    "content": text
//                ]
//            ]
//        ]
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
//        } catch {
//            completion(nil)
//            return
//        }
//        
//        task = session.dataTask(with: request) { data, _, error in
//            guard
//                error == nil,
//                let data = data
//            else {
//                completion(error.debugDescription)
//                return
//            }
//            
//            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
//            print(json)
//            let choices = json?["choices"] as? [[String: Any]]
//            let message = choices?.first!["message"] as? [String: Any]
//            let content = message?["content"] as? String
//            completion(content)
//        }
//        task?.resume()
//    }
//    
//    private func sendMessageUsingGemini(text: String, completion: @escaping (String?) -> Void) {
//        task?.cancel()
//        
//        var request = URLRequest(url: apiURLGemini)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let jsonBody: [String: Any] = [
//            "contents": [
//                [
//                    "parts": [
//                        [
//                            "text": text
//                        ]
//                    ]
//                ]
//            ]
//        ]
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
//        } catch {
//            completion(nil)
//            return
//        }
//        
//        task = URLSession.shared.dataTask(with: request) { data, _, error in
//            guard
//                error == nil,
//                let data = data
//            else {
//                completion(error.debugDescription)
//                return
//            }
//            
//            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
//            let candidates = json?["candidates"] as? [[String: Any]]
//            print(candidates)
//            let firstCandidate = candidates?.first
//            let content = firstCandidate?["content"] as? [String: Any]
//            let parts = content?["parts"] as? [[String: Any]]
//            let firstPart = parts?.first
//            let text = firstPart?["text"] as? String
//            print(text)
//            completion(text)
//        }
//        task?.resume()
//    }
}

// MARK: Extensions

extension ViewController: ViewControllerInput {
    
    func showResponse(_ response: String) {
        responseLabel.text = response
//        activityIndicator.stopAnimating()
    }
    
    func showError(_ error: String) {
//        activityIndicator.stopAnimating()
        let alert = UIAlertController(title: Constant.errorTitle, message: error, preferredStyle: Constant.style)
        alert.addAction(UIAlertAction(title: Constant.actionTitle, style: Constant.actionStyle))
        self.present(alert, animated: true)
    }
}
