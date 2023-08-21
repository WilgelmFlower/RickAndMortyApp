import UIKit

final class OriginCellTableView: UITableViewCell {

    static let identifier = String(describing: OriginCellTableView.self)

    private let imageOriginal: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.image = UIImage(named: "planet")

        return image
    }()

    private let nameLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4

        return stackView
    }()

    private let nameOriginLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)

        return label
    }()

    private let locationOriginLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .green
        label.font = .systemFont(ofSize: 17)

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with name: String, location: String) {
        self.nameOriginLabel.text = name
        self.locationOriginLabel.text = location
    }

    private func setupLayout() {

        contentView.backgroundColor = UIColor(named: "cvBG")

        imageOriginal.translatesAutoresizingMaskIntoConstraints = false
        nameLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        locationOriginLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabelStackView.addArrangedSubview(nameOriginLabel)
        nameLabelStackView.addArrangedSubview(locationOriginLabel)

        contentView.addSubview(imageOriginal)
        contentView.addSubview(nameLabelStackView)

        NSLayoutConstraint.activate([
            imageOriginal.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageOriginal.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageOriginal.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imageOriginal.widthAnchor.constraint(equalTo: imageOriginal.heightAnchor, multiplier: 1),

            nameLabelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabelStackView.leadingAnchor.constraint(equalTo: imageOriginal.trailingAnchor, constant: 16),
            nameLabelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
