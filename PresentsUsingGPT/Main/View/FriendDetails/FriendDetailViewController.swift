import UIKit

final class FriendDetailViewController: UIViewController, FriendDetailViewControllerInput {

    private let presenter: FriendDetailPresenterInput
    
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let lastNameLabel = UILabel()
    private let birthDateLabel = UILabel()
    private let genderLabel = UILabel()
    private let interestsLabel = UILabel()
    private let hobbiesLabel = UILabel()
    private let roleLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let editButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)
    private let giftButton = UIButton(type: .system)
    
    init(presenter: FriendDetailPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Информация о друге"
        
        presenter.loadFriend()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFriendEdited(_:)), name: .didEditFriend, object: nil)
    }

    func updateUI(friend: Friend) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        print(friend.firstName)
        nameLabel.text = "Имя: \(friend.firstName)"
        lastNameLabel.text = "Фамилия: \(friend.lastName)"
        
        if let birthDate = friend.birthDate {
            birthDateLabel.text = "Дата рождения: \(dateFormatter.string(from: birthDate))"
        } else {
            birthDateLabel.text = "Дата рождения: Не указана"
        }
        
        genderLabel.text = "Пол: \(friend.gender ?? "Не указан")"
        interestsLabel.text = "Интересы: \(friend.interests ?? "Не указаны")"
        hobbiesLabel.text = "Хобби: \(friend.hobbies ?? "Не указаны")"
        roleLabel.text = "Роль: \(friend.role)"
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    func openChat(aiName: String) {
        if let tabBar = self.tabBarController as? MainTabBarController {
            tabBar.openChat(with: presenter.getFriend(), aiName: aiName)
        }
    }
    
    @objc private func giftButtonTapped() {
        let alert = UIAlertController(title: "Выбор ИИ", message: "С кем вы хотите поговорить?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "GigaChat", style: .default, handler: { _ in
            self.openChat(aiName: "GigaChat")
        }))
        
        alert.addAction(UIAlertAction(title: "Gemini", style: .default, handler: { _ in
            self.openChat(aiName: "Gemini")
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func handleFriendEdited(_ notification: Notification) {
        guard let (updatedFriend, index) = notification.object as? (Friend, Int),
              index == presenter.getFriendIndex() else { return }

        presenter.handleFriendEdited(friend: updatedFriend)
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "main_background")
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        [nameLabel, lastNameLabel, birthDateLabel, genderLabel, interestsLabel, hobbiesLabel, roleLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.numberOfLines = 0
            $0.textColor = .white
            stackView.addArrangedSubview($0)
        }
        
        editButton.setTitle("Редактировать", for: .normal)
        editButton.backgroundColor = .systemGreen
        editButton.setTitleColor(.white, for: .normal)
        editButton.layer.cornerRadius = 8
        editButton.addTarget(self, action: #selector(editFriend), for: .touchUpInside)
        editButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        deleteButton.setTitle("Удалить друга", for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.layer.cornerRadius = 8
        deleteButton.addTarget(self, action: #selector(confirmDelete), for: .touchUpInside)
        deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        stackView.addArrangedSubview(editButton)
        stackView.addArrangedSubview(deleteButton)

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        giftButton.setTitle("Подобрать подарок", for: .normal)
        giftButton.setTitleColor(.white, for: .normal)
        giftButton.backgroundColor = .systemPurple
        giftButton.layer.cornerRadius = 8
        giftButton.translatesAutoresizingMaskIntoConstraints = false
        giftButton.addTarget(self, action: #selector(giftButtonTapped), for: .touchUpInside)
        view.addSubview(giftButton)

        NSLayoutConstraint.activate([
            giftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            giftButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            giftButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            giftButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func editFriend() {
        let editVC = EditFriendViewController(friend: presenter.getFriend(), index: presenter.getFriendIndex())
        editVC.title = "Редактировать"
        navigationController?.pushViewController(editVC, animated: true)
    }

    @objc private func confirmDelete() {
        let alert = UIAlertController(
            title: "Удалить друга?",
            message: "Вы уверены, что хотите удалить этого друга?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            NotificationCenter.default.post(name: .didDeleteFriend, object: self.presenter.getFriendIndex())
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
