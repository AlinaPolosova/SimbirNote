//
//  ColorViewController.swift
//  SimbirNote
//
//  Created by Mac on 16.12.2024.
//

import UIKit
import SnapKit

protocol ColorViewControllerDelegate: AnyObject {
    func selectColor(name: String, color: UIColor)
}

final class ColorViewController: UIViewController {
    // MARK: Public Properties
    
    weak var delegate: ColorViewControllerDelegate?
    
    // MARK: Private Properties
    
    private let colors: [(name: String, color: UIColor)] = [
        ("Цвет по умолчанию", .dsWhite),
        ("Помидор", .dsRed),
        ("Мандарин", .dsOrange),
        ("Банан", .dsYellow),
        ("Базилик", .dsGreen),
        ("Шалфей", .dsMint),
        ("Павлин", .dsTeal),
        ("Черника", .dsBlue),
        ("Лаванда", .dsIndigo),
        ("Виноград", .dsPurple),
        ("Фламинго", .dsPink),
        ("Графит", .dsGray)
    ]
    
    // MARK: UI
    
    private let tableView = UITableView()
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - Setup UI

private extension ColorViewController {
    func setupUI() {
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellClass: ColorCell.self)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ColorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ColorCell = tableView.dequeueReusableCell(for: indexPath)
        let model = colors[indexPath.row]
        cell.configure(text: model.name, color: model.color)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = colors[indexPath.row]
        delegate?.selectColor(name: model.name, color: model.color)
    }
}
