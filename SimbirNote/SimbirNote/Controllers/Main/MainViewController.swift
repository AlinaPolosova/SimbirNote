//
//  ViewController.swift
//  SimbirNote
//
//  Created by Mac on 11.12.2024.
//

import UIKit
import FSCalendar
import SnapKit
import RealmSwift

final class MainViewController: UIViewController {
    // MARK: Public Properties
    
    var presenter: MainPresenterProtocol?
    
    // MARK: UI
    
    private let calendar = FSCalendar()
    private var calendarHeightConstraint: Constraint?
    private let switchSizeCalendarButton = UIButton()
    private let tableView = UITableView()
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setupUI()
    }
}

// MARK: - MainViewControllerProtocol

extension MainViewController: MainViewControllerProtocol {
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - Setup UI

private extension MainViewController {
    func setupUI() {
        setupAddBarButton()
        setupView()
        setupCalendar()
        setupSwitchSizeCalendarButton()
        setupTableView()
    }
    
    func setupView() {
        title = "SimbirNote"
    }
    
    func setupCalendar() {
        view.addSubview(calendar)
        calendar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            calendarHeightConstraint = $0.height.equalTo(300).constraint
        }
        calendar.delegate = self
        calendar.dataSource = self
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.firstWeekday = 2
        calendar.scope = .week
    }
    
    func setupSwitchSizeCalendarButton() {
        view.addSubview(switchSizeCalendarButton)
        switchSizeCalendarButton.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(CGFloat.px16)
            $0.leading.equalToSuperview().inset(CGFloat.px16)
            $0.height.equalTo(CGFloat.px32)
        }
        switchSizeCalendarButton.setTitle("Открыть календарь", for: .normal)
        switchSizeCalendarButton.setTitleColor(.black, for: .normal)
        switchSizeCalendarButton.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 14)
        switchSizeCalendarButton.addTarget(
            self,
            action: #selector(switchSizeCalendarButtonTapped),
            for: .touchUpInside
        )
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(switchSizeCalendarButton.snp.bottom).offset(CGFloat.px16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellClass: NoteCell.self)
        tableView.separatorStyle = .none
    }
    
    func setupAddBarButton() {
        let addButtton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(tapAddButton)
        )
        navigationItem.setRightBarButton(addButtton, animated: true)
    }
}

// MARK: - Actions

private extension MainViewController {
    @objc func switchSizeCalendarButtonTapped() {
        if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            switchSizeCalendarButton.setTitle("Закрыть календарь", for: .normal)
        } else {
            calendar.setScope(.week, animated: true)
            switchSizeCalendarButton.setTitle("Открыть календарь", for: .normal)
        }
    }
    
    @objc func tapAddButton() {
        let storyboard = UIStoryboard(name: "CreateNote", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "CreateNoteViewController") as? CreateNoteViewController {
            let presenter = CreateNotePresenter(
                view: detailVC,
                isEditFlow: false,
                note: nil
            )
            detailVC.presenter = presenter
            detailVC.delegate = self
            navigationController?.present(detailVC, animated: true)
        }
    }
}

// MARK: - FSCalendarDataSource, FSCalendarDelegate

extension MainViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint?.layoutConstraints.first?.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        presenter?.sortedDate(currentDate: date)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?._times.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < presenter?._groupedNotes.count ?? 0 else { return 0 }
        return presenter?._groupedNotes[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoteCell = tableView.dequeueReusableCell(for: indexPath)
        if let model = presenter?._groupedNotes[indexPath.section][indexPath.row] {
            cell.configure(
                time: model.time,
                name: model.name,
                color: model.color?.color
            )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            if let noteToDelete = presenter?._groupedNotes[indexPath.section][indexPath.row] {
                RealmManager.shared.deleteNote(model: noteToDelete)
                presenter?.removeGroupedNote(indexPath)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
        }
        
        deleteAction.backgroundColor = .red
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash")
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = NoteHeader()
        header.configure(title: presenter?._times[section] ?? "")
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CreateNote", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "CreateNoteViewController") as? CreateNoteViewController {
            detailVC.delegate = self
            if let model = presenter?._groupedNotes[indexPath.section][indexPath.row]{
                let presenter = CreateNotePresenter(
                    view: detailVC,
                    isEditFlow: true,
                    note: model
                )
                detailVC.presenter = presenter
                navigationController?.present(detailVC, animated: true)
            }
        }
    }
}

// MARK: - CreateNoteViewControllerDelegate

extension MainViewController: CreateNoteViewControllerDelegate {
    func reloadTableView() {
        let date = calendar.selectedDate ?? Date()
        presenter?.sortedDate(currentDate: date)
    }
}
