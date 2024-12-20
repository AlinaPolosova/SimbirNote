//
//  MainPresenter.swift
//  SimbirNote
//
//  Created by Mac on 20.12.2024.
//

import RealmSwift

final class MainPresenter {
    // MARK: Public Properties
    
    weak var view: MainViewControllerProtocol?
    
    // MARK: Private Properties
    
    private let times = [
        "00:00",
        "01:00",
        "02:00",
        "03:00",
        "04:00",
        "05:00",
        "06:00",
        "07:00",
        "08:00",
        "09:00",
        "10:00",
        "11:00",
        "12:00",
        "13:00",
        "14:00",
        "15:00",
        "16:00",
        "17:00",
        "18:00",
        "19:00",
        "20:00",
        "21:00",
        "22:00",
        "23:00"
    ]
    
    private let localRealm = try? Realm()
    private var notes: Results<Note>?
    private var selectDateNotes: [Note] = []
    private var groupedNotes: [[Note]] = []
    
    init(view: MainViewControllerProtocol?) {
        self.view = view
    }
}

// MARK: - MainViewControllerProtocol

extension MainPresenter: MainPresenterProtocol {
    var _times: [String] {
        return times
    }
    
    var _groupedNotes: [[Note]] {
        return groupedNotes
    }
    
    func viewDidLoad() {
        notes = localRealm?.objects(Note.self)
        sortedDate(currentDate: Date())
    }
    
    func sortedDate(currentDate: Date) {
        let arrayNotes: [Note] = Array(notes?.compactMap { note in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dateFormatter.locale = Locale(identifier: "ru_RU")
            
            if let date = dateFormatter.date(from: note.date) {
                return Calendar.current.startOfDay(for: date) == Calendar.current.startOfDay(for: currentDate) ? note : nil
            } else {
                return nil
            }
        } ?? [])
        selectDateNotes = arrayNotes
        groupNotesByHour()
        view?.reloadData()
    }
    
    func removeGroupedNote(_ indexPath: IndexPath) {
        groupedNotes[indexPath.section].remove(at: indexPath.row)
    }
    
    func groupNotesByHour() {
        groupedNotes = Array(repeating: [], count: times.count)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        for note in selectDateNotes {
            if let date = dateFormatter.date(from: note.time) {
                let hour = Calendar.current.component(.hour, from: date)
                groupedNotes[hour].append(note)
            }
        }
    }
}
