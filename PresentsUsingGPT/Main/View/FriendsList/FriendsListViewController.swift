import UIKit
import Foundation

final class FriendsListViewController: UIViewController, FriendsListViewControllerInput {
    
    // MARK: Private properties
    
    private let tableView = UITableView()
    private let presenter: FriendsListPresenterInput
    
    // MARK: Init
    
    init(presenter: FriendsListPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Список друзей"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: Constant.errorTitle, message: message, preferredStyle: Constant.style)
        alert.addAction(UIAlertAction(title: Constant.actionTitle, style: Constant.actionStyle))
        self.present(alert, animated: true)
    }
    
    // MARK: Private functions
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "main_background")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "main_background")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriendTapped))
    }
    
    @objc private func addFriendTapped() {
        let addVC = AddFriendViewController()
        navigationController?.pushViewController(addVC, animated: true)
    }
}

// MARK: Extension

extension FriendsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Internal functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfFriends()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        if let friend = presenter.friend(at: indexPath.row) {
            cell.configure(with: friend)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let friend = presenter.friend(at: indexPath.row) {
            let detailVC = FriendDetailViewController(presenter: FriendDetailPresenter(friend: friend, index: indexPath.row))
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}




