import UIKit

final class ChatViewController: UIViewController, ChatViewControllerInput {
    
    // MARK: Private properties
    
    private let presenter: ChatViewControllerPresenterInput
    
    private let scrollView = UIScrollView()
    private let messageStackView = UIStackView()
    private let messageTextField = UITextField()
    private let sendButton = UIButton(type: .system)
    private let aiSelector = UISegmentedControl(items: ["GigaChat", "Gemini"])
    
    // MARK: Init
    
    init(presenter: ChatViewControllerPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "main_background")
        setupUI()
        setupConstraints()
        presenter.configure(with: presenter.currentFriend() ?? nil, aiName: presenter.currentAIName() ?? "")
    }
    
    func configure(with friend: Friend, aiName: String) {
        presenter.configure(with: friend, aiName: aiName)
    }
    
    func addMessage(_ text: String, isFromUser: Bool) {
        let label = PaddingLabel()
        label.text = text
        label.numberOfLines = 0
        label.layer.cornerRadius = 14
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 16)

        if isFromUser {
            label.backgroundColor = .white
            label.textColor = .black
            label.textAlignment = .right
            label.textInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 16)
        } else {
            label.backgroundColor = .darkGray
            label.textColor = .white
            label.textAlignment = .left
            label.textInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 20)
        }

        messageStackView.addArrangedSubview(label)
        scrollView.layoutIfNeeded()

        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        if bottomOffset.y > 0 {
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: Constant.errorTitle, message: error, preferredStyle: Constant.style)
        alert.addAction(UIAlertAction(title: Constant.actionTitle, style: Constant.actionStyle))
        self.present(alert, animated: true)
    }
    
    func sendMessage(isFromUser: Bool) {
        let text = "Представь, что ты — \(presenter.currentFriend()?.role ?? ""), пол: \(presenter.currentFriend()?.gender ?? ""), с интересами в \(presenter.currentFriend()?.interests ?? ""), и хобби: \(presenter.currentFriend()?.hobbies ?? ""). Помоги мне выбрать подарок для этого человека, основываясь на его интересах, хобби и предпочтениях. Коротко."
        addMessage(text, isFromUser: true)
        
        presenter.sendPrompt(text)
        
        messageTextField.text = ""
    }
    
    private func setupUI() {

        if presenter.currentAIName() == "GigaChat" {
            aiSelector.selectedSegmentIndex = 0
        } else {
            aiSelector.selectedSegmentIndex = 1
        }
        aiSelector.backgroundColor = .darkGray
        aiSelector.selectedSegmentTintColor = .white
        aiSelector.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        aiSelector.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        aiSelector.addTarget(self, action: #selector(aiChanged), for: .valueChanged)
        aiSelector.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(aiSelector)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        messageStackView.axis = .vertical
        messageStackView.spacing = 12
        messageStackView.alignment = .leading
        messageStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(messageStackView)

        messageTextField.placeholder = "Введите сообщение..."
        messageTextField.backgroundColor = .white
        messageTextField.textColor = .black
        messageTextField.layer.cornerRadius = 12
        messageTextField.setLeftPaddingPoints(12)
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageTextField)

        sendButton.setTitle("➤", for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 22)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.backgroundColor = .white
        sendButton.layer.cornerRadius = 12
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        view.addSubview(sendButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            aiSelector.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            aiSelector.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aiSelector.widthAnchor.constraint(equalToConstant: 220),

            scrollView.topAnchor.constraint(equalTo: aiSelector.bottomAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            scrollView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor, constant: -12),

            messageStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            messageStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            messageStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            messageStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            messageStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            messageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            messageTextField.heightAnchor.constraint(equalToConstant: 44),

            sendButton.leadingAnchor.constraint(equalTo: messageTextField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            sendButton.bottomAnchor.constraint(equalTo: messageTextField.bottomAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 44),
            sendButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func aiChanged(_ sender: UISegmentedControl) {
        presenter.setAIName(name: aiSelector.titleForSegment(at: sender.selectedSegmentIndex) ?? "GigaChat")
    }

    @objc private func sendTapped() {
        guard let text = messageTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        addMessage(text, isFromUser: true)

        presenter.sendPrompt(text)

        messageTextField.text = ""
    }
    
}

class PaddingLabel: UILabel {
    var textInsets = UIEdgeInsets.zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
