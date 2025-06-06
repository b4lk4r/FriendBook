import UIKit
import Foundation

class AddFriendViewController: UIViewController {

    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    let nameField = UITextField()
    let lastNameField = UITextField()
    let rolePicker = UIPickerView()
    let saveButton = UIButton()
    let birthDatePicker = UIDatePicker()
    let genderControl = UISegmentedControl(items: ["Мужской", "Женский"])
    let interestsField = UITextField()
    let hobbiesField = UITextField()

    let roles = ["друг", "знакомый", "я"]
    var selectedRole: String = "друг"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.04, green: 0.14, blue: 0.24, alpha: 1.0)
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // позволяет нажимать на кнопки и другие элементы
        view.addGestureRecognizer(tapGesture)
    }

    private func setupUI() {
        title = "Добавить друга"

        // Настройка полей
        [nameField, lastNameField, interestsField, hobbiesField].forEach {
            $0.borderStyle = .roundedRect
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setLeftPaddingPoints(8)
            $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        nameField.placeholder = "Введите имя"
        lastNameField.placeholder = "Введите фамилию"
        interestsField.placeholder = "Интересы"
        hobbiesField.placeholder = "Хобби"

        rolePicker.dataSource = self
        rolePicker.delegate = self
        rolePicker.translatesAutoresizingMaskIntoConstraints = false
        rolePicker.heightAnchor.constraint(equalToConstant: 120).isActive = true

        saveButton.setTitle("Сохранить друга", for: .normal)
        saveButton.backgroundColor = UIColor.systemGreen
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveFriend), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        birthDatePicker.datePickerMode = .date
        birthDatePicker.preferredDatePickerStyle = .wheels
        birthDatePicker.maximumDate = Date()
        birthDatePicker.translatesAutoresizingMaskIntoConstraints = false
        birthDatePicker.heightAnchor.constraint(equalToConstant: 150).isActive = true
        birthDatePicker.overrideUserInterfaceStyle = .dark
        birthDatePicker.tintColor = .white

        genderControl.selectedSegmentIndex = 0
        genderControl.backgroundColor = .systemGray5
        genderControl.selectedSegmentTintColor = .systemBlue
        genderControl.translatesAutoresizingMaskIntoConstraints = false
        genderControl.heightAnchor.constraint(equalToConstant: 32).isActive = true
        genderControl.addTarget(self, action: #selector(genderChanged), for: .valueChanged)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])

        contentStackView.addArrangedSubview(nameField)
        contentStackView.addArrangedSubview(lastNameField)
        contentStackView.addArrangedSubview(birthDatePicker)
        contentStackView.addArrangedSubview(genderControl)
        contentStackView.addArrangedSubview(interestsField)
        contentStackView.addArrangedSubview(hobbiesField)
        contentStackView.addArrangedSubview(rolePicker)
        contentStackView.addArrangedSubview(saveButton)
    }
    
    @objc private func genderChanged() {
        if genderControl.selectedSegmentIndex == 1 {
            genderControl.selectedSegmentTintColor = UIColor.systemPink
        } else {
            genderControl.selectedSegmentTintColor = UIColor.systemBlue
        }
    }

    @objc private func saveFriend() {
        guard let name = nameField.text, !name.isEmpty,
              let lastName = lastNameField.text, !lastName.isEmpty
        else
        {
            let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            present(alert, animated: true)
            return
        }
        
        let gender = genderControl.titleForSegment(at: genderControl.selectedSegmentIndex)
        let newFriend = Friend(
            firstName: name,
            lastName: lastName,
            role: selectedRole,
            birthDate: birthDatePicker.date,
            gender: gender,
            interests: interestsField.text,
            hobbies: hobbiesField.text
        )
        
        NotificationCenter.default.post(name: .didAddFriend, object: newFriend)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddFriendViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { roles.count }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: roles[row], attributes: [.foregroundColor: UIColor.white])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRole = roles[row]
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
