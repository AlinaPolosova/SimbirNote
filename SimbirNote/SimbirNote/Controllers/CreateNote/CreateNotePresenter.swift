//
//  CreateNotePresenter.swift
//  SimbirNote
//
//  Created by Mac on 19.12.2024.
//

import UIKit

final class CreateNotePresenter {
    // MARK: Public Properties
    
    weak var view: CreateNoteViewControllerProtocol?
    
    // MARK: Private Properies
    
    private var isEditFlow: Bool = false
    private var note: Note?
    private var name: String?
    private var date: String?
    private var time: String?
    private var circumscribing: String?
    private var color: UIColor = .white
    private var nameColor: String = "Цвет по умолчанию"
    
    // MARK: Init
    
    init(
        view: CreateNoteViewControllerProtocol?,
        isEditFlow: Bool,
        note: Note?
    ) {
        self.view = view
        self.isEditFlow = isEditFlow
        self.note = note
    }
}

// MARK: - CreateNotePresenterProtocol

extension CreateNotePresenter: CreateNotePresenterProtocol {
    var _date: String? {
        return date
    }
    
    var _time: String? {
        return time
    }
    
    func viewDidLoad() {
        if isEditFlow {
            editScreen()
        }
    }
    
    func editName(_ name: String?) {
        self.name = name
        isEnabledSaveButton()
    }
    
    func editDate(_ date: Date?) {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            formatter.locale = Locale(identifier: "ru_RU")
            self.date = formatter.string(from: date)
            isEnabledSaveButton()
        }
    }
    
    func editTime(_ time: Date?) {
        if let time = time {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.locale = Locale(identifier: "ru_RU")
            self.time = formatter.string(from: time)
            isEnabledSaveButton()
        }
    }
    
    func editCircumscribing(_ circumscribing: String?) {
        self.circumscribing = circumscribing
    }
    
    func editColor(name: String?, color: UIColor?) {
        self.nameColor = name ?? "Цвет по умолчанию"
        self.color = color ?? UIColor.white
    }
    
    func saveData() {
        let persistedColor = PersistedColor()
        persistedColor.color = color
        persistedColor.nameColor = nameColor
        guard let name = name,
              let date = date,
              let time = time
        else { return }
        
        if isEditFlow {
            guard let note = self.note else { return }
            RealmManager.shared.editNote(
                model: note,
                name: name,
                date: date,
                time: time,
                circumscribing: circumscribing,
                color: persistedColor
            )
        } else {
            let note = Note(
                date: date,
                time: time,
                name: name,
                circumscribing: circumscribing,
                color: persistedColor
            )
            RealmManager.shared.saveNote(model: note)
        }
    }
    
    func editScreen() {
        guard let note = note else { return }
        name = note.name
        date = note.date
        time = note.time
        circumscribing = note.circumscribing
        color = note.color?.color ?? .white
        nameColor = note.color?.nameColor ?? "Цвет по умолчанию"
        
        view?.configureView(
            name: name,
            date: date,
            time: time,
            color: color,
            nameColor: nameColor,
            circumscribing: circumscribing
        )
        isEnabledSaveButton()
    }
}

// MARK: Private Methods

private extension CreateNotePresenter {
    func isEnabledSaveButton() {
        guard !isEditFlow else {
            view?.enabledButton(true)
            return
        }
        if name != nil && name != "",
           date != nil && date != "",
           time != nil && time != "" {
            view?.enabledButton(true)
        } else {
            view?.enabledButton(false)
        }
    }
}
