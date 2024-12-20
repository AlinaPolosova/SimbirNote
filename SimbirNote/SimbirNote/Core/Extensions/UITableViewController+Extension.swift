//
//  UITableViewController+Extension.swift
//  SimbirNote
//
//  Created by Mac on 11.12.2024.
//

import UIKit

extension UITableView {
    func register<Cell: UITableViewCell>(cellClass: Cell.Type) {
        register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as? Cell else {
            fatalError("Unable to dequeue cell with identifier: $String(describing: Cell.self))")
        }
        return cell
    }
}
