//
//  NoteHeader.swift
//  SimbirNote
//
//  Created by Mac on 11.12.2024.
//

import UIKit

final class NoteHeader: UIView {
    // MARK: UI
    
    private let titleLabel = UILabel()
    private let separator = UIView()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

// MARK: - Setup UI

private extension NoteHeader {
    func setupUI() {
        setupTitleLabel()
        setupSeparator()
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(8)
        }
        titleLabel.backgroundColor = .white
    }
    
    func setupSeparator() {
        addSubview(separator)
        separator.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        separator.backgroundColor = .black
    }
}
