//
//  MapAnnotationView.swift
//  PSIMap
//
//  Created by Kevin Lo on 29/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import MapKit
import UIKit

class MapAnnotation: MKPointAnnotation {

    var name: String?

    var value: Double?

}

class MapAnnotationView: MKAnnotationView {

    var value: Double? {
        willSet {
            guard let newValue = newValue else {
                valueLabel.text = ""
                return
            }
            valueLabel.text = "\(newValue)"
        }
    }

    var name: String? {
        willSet {
            guard let newValue = newValue else {
                nameLabel.text = ""
                return
            }
            nameLabel.text = "\(newValue)".uppercased()
        }
    }

    private var valueLabel = UILabel()

    private var nameLabel = UILabel()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupSubviewsIfNecessary()
        configureStyles()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviewsIfNecessary()
        configureStyles()
    }

    private func setupSubviewsIfNecessary() {
        guard valueLabel.superview == nil || nameLabel.superview == nil else {
            return
        }
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)

        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    private func configureStyles() {
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.8).cgColor
        layer.cornerRadius = 10.0
        layer.masksToBounds = false
        valueLabel.font = UIFont.boldSystemFont(ofSize: 20)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
    }

}
