//
//  MainProtocols.swift
//  SimbirNote
//
//  Created by Mac on 20.12.2024.
//

import Foundation

protocol MainViewControllerProtocol: AnyObject {
    func reloadData()
}

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad()
    func sortedDate(currentDate: Date)
    func removeGroupedNote(_ indexPath: IndexPath)
    var _times: [String] { get }
    var _groupedNotes: [[Note]] { get }
}
