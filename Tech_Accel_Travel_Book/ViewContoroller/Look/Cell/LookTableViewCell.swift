//
//  LookTableViewCell.swift
//  Tech_Accel_Travel_Book
//
//  Created by 新垣 清奈 on 2023/02/12.
//

import Foundation
import UIKit

final class LookTableViewCell: UITableViewCell {
    static let identifier = "LookTableViewCell"

    private let startToEndTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    private let planTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(startToEndTimeLabel)
        addSubview(planTextLabel)

        backgroundColor = .white

        NSLayoutConstraint.activate([
            startToEndTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            startToEndTimeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            startToEndTimeLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            startToEndTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7)
        ])

        NSLayoutConstraint.activate([
            planTextLabel.leadingAnchor.constraint(lessThanOrEqualTo: startToEndTimeLabel.trailingAnchor, constant: 0),
            planTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            planTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            planTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setUp(startedTime: String, finishTime: String, planText: String) {
        startToEndTimeLabel.text = "\(startedTime) ~ \(finishTime)"
        planTextLabel.text = planText
    }
}
