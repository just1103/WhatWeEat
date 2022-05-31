//
//  SettingCell.swift
//  WhatWeEat
//
//  Created by 양호준 on 2022/05/31.
//

import UIKit

class SettingCell: UITableViewCell {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Design.titleLabelFont
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        self.backgroundColor = ColorPalette.subYellow
    }
    
    // MARK: - Methods
    func apply(title: String) {
        titleLabel.text = title
    }
    
    private func configureUI() {
        self.accessoryType = .disclosureIndicator
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
}

// MARK: - NameSpace
extension SettingCell {
    private enum Design {
        static let titleLabelFont: UIFont = .preferredFont(forTextStyle: .title3)
    }
}
