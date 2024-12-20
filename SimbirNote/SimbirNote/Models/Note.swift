//
//  Note.swift
//  SimbirNote
//
//  Created by Mac on 16.12.2024.
//

import RealmSwift

final class Note: Object {
    @Persisted var date: String
    @Persisted var time: String
    @Persisted var name: String
    @Persisted var circumscribing: String?
    @Persisted var color: PersistedColor?
    
    init(
        date: String,
        time: String,
        name: String,
        circumscribing: String? = nil,
        color: PersistedColor? = nil
    ) {
        self.date = date
        self.time = time
        self.name = name
        self.circumscribing = circumscribing
        self.color = color
    }
    
    required override init() {
        super.init()
    }
}
