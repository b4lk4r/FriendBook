import UIKit

class EditFriendViewController: UIViewController {

    var friend: Friend
    var friendIndex: Int

    init(friend: Friend, index: Int) {
        self.friend = friend
        self.friendIndex = index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let scrollView = UIScrollView()
    let contentView = UIView()

    let nameField = UITextField()
    let lastNameField = UITextField()
    let birthDatePicker = UIDatePicker()
    let genderControl = UISegmentedControl(items: ["Мужской", "Женский"])
    let interestsField = UITextField()
    let hobbiesField = UITextField()
    let rolePicker = UIPickerView()
    let saveButton = UIButton()

    let roles = ["друг", "знакомый", "я"]
    var selectedRole: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Редактировать друга"
        view.backgroundColor = UIColor(red: 0.04, green: 0.14, blue: 0.24, alpha: 1.0)
        setupUI()
        fillFields()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // позволяет нажимать на кнопки и другие элементы
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        let stack = UIStackView(arrangedSubviews: [
            nameField, lastNameField, birthDatePicker,
            genderControl, interestsField, hobbiesField,
            rolePicker, saveButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])

        [nameField, lastNameField, interestsField, hobbiesField].forEach {
            $0.borderStyle = .roundedRect
            //$0.backgroundColor = .white
            $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
            $0.setLeftPaddingPoints(8)
        }

        birthDatePicker.datePickerMode = .date
        birthDatePicker.preferredDatePickerStyle = .wheels
        birthDatePicker.maximumDate = Date()
        birthDatePicker.overrideUserInterfaceStyle = .dark
        birthDatePicker.tintColor = .white
        
        genderControl.backgroundColor = .systemGray5
        genderControl.selectedSegmentTintColor = .systemBlue
        genderControl.addTarget(self, action: #selector(genderChanged), for: .valueChanged)

        rolePicker.dataSource = self
        rolePicker.delegate = self
        rolePicker.heightAnchor.constraint(equalToConstant: 120).isActive = true

        saveButton.setTitle("Сохранить изменения", for: .normal)
        saveButton.backgroundColor = .systemGreen
        saveButton.layer.cornerRadius = 8
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
    }
    
    @objc private func genderChanged() {
        if genderControl.selectedSegmentIndex == 1 {
            genderControl.selectedSegmentTintColor = UIColor.systemPink
        } else {
            genderControl.selectedSegmentTintColor = UIColor.systemBlue
        }
    }

    private func fillFields() {
        nameField.text = friend.firstName
        lastNameField.text = friend.lastName
        birthDatePicker.date = friend.birthDate ?? Date()
        interestsField.text = friend.interests
        hobbiesField.text = friend.hobbies
        genderControl.selectedSegmentIndex = friend.gender == "Женский" ? 1 : 0
        if let index = roles.firstIndex(of: friend.role) {
            rolePicker.selectRow(index, inComponent: 0, animated: false)
            selectedRole = roles[index]
        }
    }

    @objc private func saveChanges() {
        guard let name = nameField.text, !name.isEmpty,
              let lastName = lastNameField.text, !lastName.isEmpty,
              let role = selectedRole else {
            let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            present(alert, animated: true)
            return
        }

        let updatedFriend = Friend(
            firstName: name,
            lastName: lastName,
            role: role,
            birthDate: birthDatePicker.date,
            gender: genderControl.titleForSegment(at: genderControl.selectedSegmentIndex),
            interests: interestsField.text,
            hobbies: hobbiesField.text
        )

        NotificationCenter.default.post(name: .didEditFriend, object: (updatedFriend, friendIndex))
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIPickerView

extension EditFriendViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        roles.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: roles[row], attributes: [.foregroundColor: UIColor.white])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRole = roles[row]
    }
}
