//
//  ViewController.swift
//  sms-input-uikit
//
//  Created by Mariana Mendes on 7/21/21.
//

import UIKit

class ViewController: UIViewController {

    var sendButton: UIButton!
    var textView: UITextView!
    var stackView: UIStackView!

    var heightConstraint: NSLayoutConstraint!
    var heightFor3Lines: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        // Set up the textView
        textView = setUpTextView()

        // Set up the sendButton
        sendButton = setUpSendButton()
        updateSendButtonState()

        // Set up the stackView
        stackView = setUpStackView()

        // Add textView and sendButton to the stackView
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(sendButton)

        // Add stackView to the main view
        self.view.addSubview(stackView)

        // Set up stackView's constraints
        setUpStackConstraints()
    }

    // MARK: - Keyboard Notifications

    @objc func keyboardWillChange(notification: NSNotification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
              return
           }

        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }


    // MARK: - Private methods

    private func setUpTextView() -> UITextView {
        textView = UITextView(frame: CGRect.zero)
        textView.backgroundColor = .clear
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 5
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = textView.heightAnchor.constraint(equalToConstant: 30.0)
        heightConstraint.isActive = true

        return textView
    }

    private func setUpSendButton() -> UIButton {
        sendButton = UIButton(frame: CGRect.zero)
        sendButton.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)

        return sendButton
    }

    @objc private func sendMessage(sender: UIButton!) {
        print("Message was sent!")
        textView.text = ""
    }

    private func updateSendButtonState() {
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }

    private func setUpStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10

        return stackView
    }

    private func setUpStackConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}


// MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {

        updateSendButtonState()

        let numberOfLines = textView.contentSize.height/(textView.font?.lineHeight)!

        if Int(numberOfLines) > 3 {
            self.heightConstraint.constant = heightFor3Lines
        } else {
            if Int(numberOfLines) == 3 {
                self.heightFor3Lines = textView.contentSize.height
            }
            self.heightConstraint.constant = textView.contentSize.height
        }
        textView.layoutIfNeeded()
    }
}
