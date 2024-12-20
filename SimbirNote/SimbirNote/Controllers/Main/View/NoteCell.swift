//
//  CellTableView.swift
//  SimbirNote
//
//  Created by Mac on 11.12.2024.
//

import UIKit
import SnapKit

final class NoteCell: UITableViewCell {
    // MARK: UI
    
    private let timeLabel = UILabel()
    private let nameLabel = UILabel()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        time: String,
        name: String,
        color: UIColor?
    ) {
        timeLabel.text = time
        nameLabel.text = name
        contentView.backgroundColor = color?.withAlphaComponent(0.5) 
    }
}

// MARK: - Setup UI

private extension NoteCell {
    func setupUI() {
        setupTimeLabel()
        setupNameLabel()
    }
    
    func setupTimeLabel() {
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview().inset(16)
        }
        timeLabel.font = UIFont.systemFont(ofSize: 25)
        timeLabel.textColor = .black
    }
    
    func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
            $0.leading.equalTo(timeLabel.snp.trailing).offset(16)
        }
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.textColor = .black
    }
}
