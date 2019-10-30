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

    var value: String?

    var valueColor: UIColor?

}

class MapAnnotationView: MKAnnotationView {

    private var valueLabel = UILabel()

    private var nameLabel = UILabel()

    override var annotation: MKAnnotation? {
        willSet {
            configureViews(with: newValue)
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupSubviewsIfNecessary()
        configureStyles()
        configureViews(with: annotation)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviewsIfNecessary()
        configureStyles()
        configureViews(with: annotation)
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
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            nameLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ])
    }

    private func configureStyles() {
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.8).cgColor
        layer.cornerRadius = 10.0
        layer.masksToBounds = false
        valueLabel.font = UIFont.boldSystemFont(ofSize: 16)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
    }

    private func configureViews(with annotation: MKAnnotation?) {
        guard let annotation = annotation as? MapAnnotation else {
            return
        }
        valueLabel.text = annotation.value
        valueLabel.textColor = annotation.valueColor ?? .white
        nameLabel.text = annotation.name?.uppercased()
    }

}
