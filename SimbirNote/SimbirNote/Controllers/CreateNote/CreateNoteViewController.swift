//
//  CreateNoteViewController.swift
//  SimbirNote
//
//  Created by Mac on 13.12.2024.
//

import UIKit

protocol CreateNoteViewControllerDelegate: AnyObject {
    func reloadTableView()
}

final class CreateNoteViewController: UIViewController {
    // MARK: Public Properties
    
    weak var delegate: CreateNoteViewControllerDelegate?
    var presenter: CreateNotePresenterProtocol?
    
    // MARK: UI
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var colorStackView: UIStackView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoad()
    }
}

// MARK: - CreateNoteViewControllerProtocol

extension CreateNoteViewController: CreateNoteViewControllerProtocol {
    func enabledButton(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
    }
    
    func configureView(
        name: String?,
        date: String?,
        time: String?,
        color: UIColor?,
        nameColor: String?,
        circumscribing: String?
    ) {
        nameTextField.text = name
        dateTextField.text = date
        timeTextField.text = time
        colorView.backgroundColor = color
        colorLabel.text = nameColor
        if let circumscribing = circumscribing {
            descriptionTextView.text = circumscribing
            descriptionTextView.textColor = .black
        }
    }
}

// MARK: - Setup UI

private extension CreateNoteViewController {
    func setupUI() {
        setupNameTextField()
        setupDateTextField()
        setupTimeTextField()
        setupDescriptionTextView()
        setupColorStackView()
        setupColorView()
        setupSaveButton()
        setupBackButton()
    }
    
    func setupNameTextField() {
        nameTextField.delegate = self
    }
    
    func setupDateTextField() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.locale = Locale(identifier: "ru_RU")
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let cancelDateButton = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(cancelDateSelection)
        )
        let saveDateButton = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(saveDateSelection)
        )
        toolbar.setItems([cancelDateButton, flexibleSpace, saveDateButton], animated: false)
        toolbar.barTintColor = UIColor(hex: "#c6cad1")
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.delegate = self
        dateTextField.inputView = datePicker
    }
    
    func setupTimeTextField() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.locale = Locale(identifier: "ru_RU")
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let cancelTimeButton = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(cancelTimeSelection)
        )
        let saveTimeButton = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(saveTimeSelection)
        )
        toolbar.setItems([cancelTimeButton, flexibleSpace, saveTimeButton], animated: false)
        toolbar.barTintColor = UIColor(hex: "#c6cad1")
        
        timeTextField.inputAccessoryView = toolbar
        timeTextField.delegate = self
        timeTextField.inputView = datePicker
    }
    
    func setupDescriptionTextView() {
        descriptionTextView.delegate = self
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.text = "Введите текст..."
    }
    
    func setupColorStackView() {
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(tapColorStackView)
        )
        colorStackView.addGestureRecognizer(gesture)
    }
    
    func setupColorView() {
        colorView.layer.cornerRadius = .px8
        colorView.backgroundColor = .white
        colorView.layer.borderColor = UIColor.black.cgColor
        colorView.layer.borderWidth = 1
    }
    
    func setupSaveButton() {
        saveButton.addTarget(
            self,
            action: #selector(tapSaveButton),
            for: .touchUpInside
        )
        saveButton.isEnabled = false
    }
    
    func setupBackButton() {
        backButton.addTarget(
            self,
            action: #selector(tapBackButton),
            for: .touchUpInside
        )
    }
}

// MARK: - Actions

private extension CreateNoteViewController {
    @objc func tapColorStackView() {
        let popOver = ColorViewController()
        popOver.delegate = self
        popOver.modalPresentationStyle = .popover
        
        guard let presentationVC = popOver.popoverPresentationController else { return }
        
        presentationVC.delegate = self
        presentationVC.sourceView = colorView
        presentationVC.permittedArrowDirections = .up
        presentationVC.sourceRect = CGRect(
            x: colorView.bounds.midX,
            y: colorView.bounds.maxY,
            width: 0,
            height: 0
        )
        present(popOver,animated: true)
    }
    
    @objc func cancelDateSelection() {
        dateTextField.resignFirstResponder()
    }
    
    @objc func saveDateSelection() {
        let datePicker = dateTextField.inputView as? UIDatePicker
        let selectedDate = datePicker?.date
        
        presenter?.editDate(selectedDate)
        dateTextField.text = presenter?._date
        dateTextField.resignFirstResponder()
    }
    
    @objc func cancelTimeSelection() {
        timeTextField.resignFirstResponder()
    }
    
    @objc func saveTimeSelection() {
        let datePicker = timeTextField.inputView as? UIDatePicker
        let selectedTime = datePicker?.date
        
        presenter?.editTime(selectedTime)
        timeTextField.text = presenter?._time
        timeTextField.resignFirstResponder()
    }
    
    @objc func tapSaveButton() {
        presenter?.saveData()
        dismiss(animated: true)
        delegate?.reloadTableView()
    }
    
    @objc func tapBackButton() {
        dismiss(animated: true)
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension CreateNoteViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

// MARK: - UITextFieldDelegate, UITextViewDelegate

extension CreateNoteViewController: UITextFieldDelegate, UITextViewDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if textField == nameTextField {
            presenter?.editName(textField.text)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        presenter?.editCircumscribing(textView.text)
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = "Введите текст..."
        } else if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        } else {
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
}

// MARK: - ColorViewControllerDelegate

extension CreateNoteViewController: ColorViewControllerDelegate {
    func selectColor(name: String, color: UIColor) {
        colorLabel.text = name
        colorView.backgroundColor = color
        presenter?.editColor(name: name, color: color)
        dismiss(animated: true)
    }
}
