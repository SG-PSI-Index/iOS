//
//  MapErrorView.swift
//  PSIMap
//
//  Created by Kevin Lo on 1/11/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import UIKit

class MapErrorView: UIView {

    var errorMessage: String? {
        willSet {
            messageLabel?.text = newValue
        }
    }

    var retryHandler: (() -> Void)?

    func startLoading() {
        spinner?.startAnimating()
        messageLabel?.isHidden = true
        retryButton?.isHidden = true
    }

    func stopLoading() {
        spinner?.stopAnimating()
        messageLabel?.isHidden = false
        retryButton?.isHidden = false
    }

    private var messageLabel: UILabel?

    private var retryButton: UIButton?

    private var spinner: UIActivityIndicatorView?

    private func setupViews() {
        guard subviews.isEmpty else {
            return
        }

        backgroundColor = .black

        let messageLabel = UILabel()
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.text = errorMessage
        addSubview(messageLabel)
        self.messageLabel = messageLabel

        let retryButton = UIButton(type: .roundedRect)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.addTarget(self, action: #selector(performRetry), for: .touchUpInside)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(retryButton)
        self.retryButton = retryButton

        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)
        self.spinner = spinner

        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            messageLabel.bottomAnchor.constraint(
                equalTo: centerYAnchor,
                constant: -8
            ),
            retryButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            retryButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            retryButton.topAnchor.constraint(
                equalTo: centerYAnchor,
                constant: 8
            ),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @objc private func performRetry() {
        retryHandler?()
    }

}

extension MapErrorView {

    override func layoutSubviews() {
        setupViews()
        super.layoutSubviews()
    }

}
