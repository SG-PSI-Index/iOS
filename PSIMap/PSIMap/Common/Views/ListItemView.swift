//
//  ListItemView.swift
//  PSIMap
//
//  Created by Kevin Lo on 30/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import UIKit

class ListItemView: UIView {

    var title: String? {
        willSet {
            titleLabel.text = newValue
        }
    }

    var subtitle: String? {
        willSet {
            subtitleLabel.text = newValue
        }
    }

    var rightDetails: String? {
        willSet {
            rightDetailsLabel.text = newValue
        }
    }

    var rightDetailsColor: UIColor? {
        willSet {
            rightDetailsLabel.textColor = newValue ?? .white
        }
    }

    private let titleLabel = UILabel()

    private let subtitleLabel = UILabel()

    private let rightDetailsLabel = UILabel()

}

extension ListItemView {

    override func layoutSubviews() {
        setupLayout()
        setupViews()
        super.layoutSubviews()
    }

}

extension ListItemView {

    private func setupLayout() {
        guard subviews.isEmpty else {
            return
        }

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subtitleLabel)
        rightDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightDetailsLabel)

        layoutMargins.left = 16
        layoutMargins.right = 16
        layoutMargins.top = 8
        layoutMargins.bottom = 8

        NSLayoutConstraint.activate([
            layoutMarginsGuide.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            layoutMarginsGuide.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(
                equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1
            ),
            layoutMarginsGuide.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: rightDetailsLabel.trailingAnchor),
            centerYAnchor.constraint(equalTo: rightDetailsLabel.centerYAnchor),
            rightDetailsLabel.leadingAnchor.constraint(
                greaterThanOrEqualToSystemSpacingAfter: titleLabel.trailingAnchor,
                multiplier: 1
            ),
            rightDetailsLabel.leadingAnchor.constraint(
                greaterThanOrEqualToSystemSpacingAfter: subtitleLabel.trailingAnchor,
                multiplier: 1
            )
        ])
    }

    private func setupViews() {
        layer.backgroundColor = UIColor(white: 0.15, alpha: 1).cgColor
        layer.cornerRadius = 5.0
        layer.masksToBounds = false
        titleLabel.textColor = .white
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        rightDetailsLabel.textColor = .white
        rightDetailsLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }

}
