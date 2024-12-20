//
//  ColorCell.swift
//  SimbirNote
//
//  Created by Mac on 16.12.2024.
//

import UIKit
import SnapKit

final class ColorCell: UITableViewCell {
    // MARK: UI
    
    private let label = UILabel()
    private let colorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String, color: UIColor) {
        label.text = text
        colorView.backgroundColor = color
    }
}

// MARK: - Setup UI

private extension ColorCell {
    func setupUI() {
        setupLabel()
        setupColorView()
    }
    
    func setupLabel() {
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview().inset(CGFloat.px16)
        }
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
    }
    
    func setupColorView() {
        contentView.addSubview(colorView)
        colorView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(CGFloat.px16)
            $0.trailing.equalToSuperview().inset(CGFloat.px16)
            $0.leading.equalTo(label.snp.trailing).offset(CGFloat.px16)
            $0.size.equalTo(CGFloat.px24)
        }
        colorView.layer.cornerRadius = CGFloat.px8
        colorView.clipsToBounds = true
        colorView.layer.borderColor = UIColor.black.cgColor
        colorView.layer.borderWidth = 1
    }
}
