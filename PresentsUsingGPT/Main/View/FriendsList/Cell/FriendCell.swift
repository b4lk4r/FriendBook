import UIKit

final class FriendCell: UITableViewCell {

    // MARK: Private properties

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let roleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pin")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private functions

    private func setupViews() {
        contentView.addSubviews(avatarImageView, nameLabel, roleLabel, pinImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: pinImageView.leadingAnchor, constant: -16),

            roleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            roleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            roleLabel.trailingAnchor.constraint(lessThanOrEqualTo: pinImageView.leadingAnchor, constant: -16),

            pinImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pinImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pinImageView.widthAnchor.constraint(equalToConstant: 20),
            pinImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupAppearance() {
        backgroundColor = UIColor(named: "main_background")
        contentView.backgroundColor = UIColor(named: "mainB_background")
        selectionStyle = .none
    }

    // MARK: Internal functions

    func configure(with friend: Friend) {
        nameLabel.text = "\(friend.lastName) \(friend.firstName)"
        roleLabel.text = friend.role
        pinImageView.isHidden = friend.role != "я"
    }
}

// MARK: Private extension

private extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
