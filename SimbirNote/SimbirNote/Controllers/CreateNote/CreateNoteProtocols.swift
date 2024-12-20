//
//  CreateNoteProtocols.swift
//  SimbirNote
//
//  Created by Mac on 19.12.2024.
//

import UIKit

protocol CreateNoteViewControllerProtocol: AnyObject {
    func enabledButton(_ isEnabled: Bool)
    func configureView(
        name: String?,
        date: String?,
        time: String?,
        color: UIColor?,
        nameColor: String?,
        circumscribing: String?
    )
}

protocol CreateNotePresenterProtocol: AnyObject {
    func editName(_ name: String?) 
    func editDate(_ date: Date?)
    func editTime(_ time: Date?)
    func editCircumscribing(_ circumscribing: String?)
    func editColor(name: String?, color: UIColor?)
    func saveData()
    func viewDidLoad()
    var _date: String? { get }
    var _time: String? { get }
}
