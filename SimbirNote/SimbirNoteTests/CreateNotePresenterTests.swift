//
//  SimbirNoteTests.swift
//  SimbirNoteTests
//
//  Created by Mac on 20.12.2024.
//

import XCTest
@testable import SimbirNote

final class CreateNotePresenterTests: XCTestCase {
    var presenter: CreateNotePresenter!
    var mockView: MockCreateNoteView!
    var mockNote: Note!

    override func setUp() {
        super.setUp()
        mockView = MockCreateNoteView()
        mockNote = Note(
            date: "20 декабря 2024",
            time: "10:00",
            name: "Test Note",
            circumscribing: "Test Description",
            color: PersistedColor()
        )
        presenter = CreateNotePresenter(
            view: mockView,
            isEditFlow: false,
            note: nil
        )
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockNote = nil
        super.tearDown()
    }

    func testViewDidLoad_inEditFlow_configuresViewCorrectly() {
        presenter = CreateNotePresenter(view: mockView, isEditFlow: true, note: mockNote)
        presenter.viewDidLoad()
        
        XCTAssertEqual(mockView.configuredName, mockNote.name)
        XCTAssertEqual(mockView.configuredDate, mockNote.date)
        XCTAssertEqual(mockView.configuredTime, mockNote.time)
        XCTAssertEqual(mockView.configuredCircumscribing, mockNote.circumscribing)
    }

    func testEditDate_formatsAndUpdatesDate() {
        let date = Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 20))!
        presenter.editDate(date)
        
        XCTAssertEqual(presenter._date, "20 декабря 2024")
    }

    func testEditTime_formatsAndUpdatesTime() {
        let time = Calendar.current.date(from: DateComponents(hour: 10, minute: 30))!
        presenter.editTime(time)
        
        XCTAssertEqual(presenter._time, "10:30")
    }

    func testSaveData_savesNoteCorrectly() {
        presenter.editName("Test Name")
        presenter.editDate(Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 20)))
        presenter.editTime(Calendar.current.date(from: DateComponents(hour: 10, minute: 30)))
        
        presenter.saveData()
    }
}

// MARK: - Mock View

final class MockCreateNoteView: CreateNoteViewControllerProtocol {
    var isButtonEnabled = false
    var configuredName: String?
    var configuredDate: String?
    var configuredTime: String?
    var configuredCircumscribing: String?

    func enabledButton(_ isEnabled: Bool) {
        isButtonEnabled = isEnabled
    }

    func configureView(
        name: String?,
        date: String?,
        time: String?,
        color: UIColor?,
        nameColor: String?,
        circumscribing: String?
    ) {
        configuredName = name
        configuredDate = date
        configuredTime = time
        configuredCircumscribing = circumscribing
    }
}
