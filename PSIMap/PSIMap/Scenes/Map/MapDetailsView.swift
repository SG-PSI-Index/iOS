//
//  MapDetailsView.swift
//  PSIMap
//
//  Created by Kevin Lo on 30/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import MapKit
import UIKit

class MapDetailsView: UIScrollView {

    let tabView = UISegmentedControl()

    let mapView = MKMapView()

    let titleLabel = UILabel()

    var additionalViews = [UIView]() {
        willSet {
            for subview in stackView.arrangedSubviews {
                stackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
            newValue.forEach { stackView.addArrangedSubview($0) }
        }
    }

    private let stackView = UIStackView()

}

extension MapDetailsView {

    override func layoutSubviews() {
        setupLayout()
        super.layoutSubviews()
    }

}

extension MapDetailsView {

    private func setupLayout() {
        guard tabView.superview == nil ||
            mapView.superview == nil ||
            titleLabel.superview == nil
            else {
                return
        }

        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tabView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tabView)
        addSubview(mapView)
        addSubview(titleLabel)
        addSubview(stackView)

        NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-16-[tab]-16-[map]-16-[title]-16-[stack]-16-|",
            options: [],
            metrics: nil,
            views: ["tab": tabView, "map": mapView, "title": titleLabel, "stack": stackView]
        ).forEach { $0.isActive = true }

        layoutMargins.left = 16
        layoutMargins.right = 16

        NSLayoutConstraint.activate([
            layoutMarginsGuide.leadingAnchor.constraint(equalTo: tabView.leadingAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: tabView.trailingAnchor),
            leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            widthAnchor.constraint(equalTo: mapView.widthAnchor),
            mapView.widthAnchor.constraint(equalTo: mapView.heightAnchor),
            layoutMarginsGuide.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            layoutMarginsGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])

        setupViews()
    }

    private func setupViews() {
        backgroundColor = .black

        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false

        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.textColor = .white
        titleLabel.text = "Singapore"

        tabView.insertSegment(withTitle: "24h PSI", at: 0, animated: false)
        tabView.insertSegment(withTitle: "1h PM2.5", at: 1, animated: false)
        tabView.selectedSegmentIndex = 0
    }

}
