//
//  RealmManager.swift
//  SimbirNote
//
//  Created by Mac on 16.12.2024.
//

import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    let localeRealm = try! Realm()
    
    private init() {}
    
    func saveNote(model: Note) {
        try! localeRealm.write({
            localeRealm.add(model)
        })
    }
    
    func deleteNote(model: Note) {
        try! localeRealm.write({
            localeRealm.delete(model)
        })
    }
    
    func deleteNotes() {
        localeRealm.deleteAll()
    }
    
    func editNote(
        model: Note,
        name: String,
        date: String,
        time: String,
        circumscribing: String?,
        color: PersistedColor
    ) {
        try! localeRealm.write({
            model.name = name
            model.date = date
            model.time = time
            model.circumscribing = circumscribing
            model.color = color
        })
    }
}
