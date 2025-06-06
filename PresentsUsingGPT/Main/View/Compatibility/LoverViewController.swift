import UIKit

class LoverViewController: UIViewController {

    private let friend1Field = UITextField()
    private let friend2Field = UITextField()
    private let selectButton = UIButton(type: .custom)

    private let pickerView = UIPickerView()
    private var currentPickerField: UITextField?

    var friends: [Friend] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }

    private var selectedFriend1: Friend?
    private var selectedFriend2: Friend?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Проверка совместимости"
        loadFriends()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "main_background")
        setupUI()
        setupPicker()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        view.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(friendDeleted), name: .didDeleteFriend, object: nil)
    }

    private func setupUI() {
        friend1Field.placeholder = "Выберите первого друга"
        friend2Field.placeholder = "Выберите второго друга"
        
        [friend1Field, friend2Field].forEach {
            $0.borderStyle = .roundedRect
            $0.textColor = .black
            $0.backgroundColor = .white
            $0.tintColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.inputView = pickerView
            view.addSubview($0)
        }

        friend1Field.addTarget(self, action: #selector(fieldTapped(_:)), for: .editingDidBegin)
        friend2Field.addTarget(self, action: #selector(fieldTapped(_:)), for: .editingDidBegin)

        if let buttonImage = UIImage(named: "check_love") {
            selectButton.setImage(buttonImage, for: .normal)
        } else {
            selectButton.setTitle("Проверить", for: .normal)
        }
        
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.addTarget(self, action: #selector(showResult), for: .touchUpInside)
        view.addSubview(selectButton)

        NSLayoutConstraint.activate([
            friend1Field.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            friend1Field.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            friend1Field.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            friend1Field.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            friend1Field.heightAnchor.constraint(equalToConstant: 44),

            selectButton.topAnchor.constraint(equalTo: friend1Field.bottomAnchor, constant: 20),
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.widthAnchor.constraint(equalToConstant: 80),
            selectButton.heightAnchor.constraint(equalToConstant: 80),
            
            friend2Field.topAnchor.constraint(equalTo: selectButton.bottomAnchor, constant: 20),
            friend2Field.leadingAnchor.constraint(equalTo: friend1Field.leadingAnchor),
            friend2Field.trailingAnchor.constraint(equalTo: friend1Field.trailingAnchor),
            friend2Field.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    private func setupPicker() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }

    @objc private func fieldTapped(_ sender: UITextField) {
        currentPickerField = sender
        if let index = (sender == friend1Field ? selectedFriend1 : selectedFriend2).flatMap({ friends.firstIndex(of: $0) }) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }

    private func loadFriends() {
        let savedFriends = FriendsDataManager.shared.getFriends()
        friends = savedFriends
        pickerView.reloadAllComponents()
    }

    @objc private func showResult() {
        guard let friend1 = selectedFriend1, let friend2 = selectedFriend2, friend1 != friend2 else {
            let alert = UIAlertController(title: "Ошибка", message: "Выберите двух разных друзей", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let resultVC = ResultViewController(friend1: friend1, friend2: friend2, geminiService: AppModule.shared.resolve(GeminiServiceInput.self))
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)
    }

    @objc private func friendDeleted(_ notification: Notification) {
        loadFriends()
    }
}

// MARK: UIPickerView

extension LoverViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        friends.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(friends[row].firstName) \(friends[row].lastName)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard friends.indices.contains(row) else { return }

        let selected = friends[row]
        guard let field = currentPickerField else { return }

        if field == friend1Field {
            selectedFriend1 = selected
            friend1Field.text = "\(selected.firstName) \(selected.lastName)"
        } else if field == friend2Field {
            selectedFriend2 = selected
            friend2Field.text = "\(selected.firstName) \(selected.lastName)"
        }
        field.resignFirstResponder()
    }
}
