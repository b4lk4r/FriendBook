import UIKit

class ResultViewController: UIViewController {

    let friend1: Friend
    let friend2: Friend

    private let resultLabel = UILabel()
    private let geminiService: GeminiServiceInput

    init(friend1: Friend, friend2: Friend, geminiService: GeminiServiceInput) {
        self.friend1 = friend1
        self.friend2 = friend2
        self.geminiService = geminiService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.04, green: 0.14, blue: 0.24, alpha: 1.0)
        title = "Результат совместимости"
        setupUI()
        calculateCompatibility()
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: Constant.errorTitle, message: error, preferredStyle: Constant.style)
        alert.addAction(UIAlertAction(title: Constant.actionTitle, style: Constant.actionStyle))
        self.present(alert, animated: true)
    }

    private func setupUI() {
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
        resultLabel.textColor = .white
        resultLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)

        view.addSubview(resultLabel)

        NSLayoutConstraint.activate([
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func calculateCompatibility() {
        let text = """
            Оцени совместимость двух людей: \(friend1.firstName) и \(friend2.firstName). Опиши их совместимость по следующим параметрам:
            - Дата рождения первого: \(friend1.birthDate?.description ?? ""), дата рождения второго: \(friend2.birthDate?.description ?? "")
            - Интересы первого: \(friend1.interests ?? ""), интересы второго: \(friend2.interests ?? "")
            - Хобби первого: \(friend1.hobbies ?? ""), хобби второго: \(friend2.hobbies ?? "")
            - На основе этих факторов, оцени процент совместимости от 0 до 100%.
            ВЕРНИ ТОЛЬКО количество процентов
            """
        geminiService.sendPrompt(text) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.resultLabel.text = """
                    \(self?.friend1.firstName ?? "") ❤️ \(self?.friend2.firstName ?? "")
                    
                    Совместимость: \(response)
                    """
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }
}
