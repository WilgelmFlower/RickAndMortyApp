import UIKit

final class EpisodesTableViewCell: UITableViewCell {

    static let identifier = String(describing: EpisodesTableViewCell.self)

    private let stackViewLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing

        return stack
    }()

    private let nameEpisodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .bold)

        return label
    }()

    private let numberEpisodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)

        return label
    }()

    private let dateEpisodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "grayNormal")
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with episodeTitle: String, episodeNumber: String, episodeDate: String) {
        self.nameEpisodeLabel.text = episodeTitle
        self.numberEpisodeLabel.text = episodeNumber
        self.dateEpisodeLabel.text = episodeDate
    }

    private func setupLayout() {
        contentView.backgroundColor = UIColor(named: "cvBG")

        nameEpisodeLabel.translatesAutoresizingMaskIntoConstraints = false
        numberEpisodeLabel.translatesAutoresizingMaskIntoConstraints = false
        dateEpisodeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackViewLabels.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(nameEpisodeLabel)
        contentView.addSubview(stackViewLabels)

        stackViewLabels.addArrangedSubview(numberEpisodeLabel)
        stackViewLabels.addArrangedSubview(dateEpisodeLabel)

        NSLayoutConstraint.activate([
            nameEpisodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameEpisodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            nameEpisodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            stackViewLabels.topAnchor.constraint(equalTo: nameEpisodeLabel.bottomAnchor, constant: 8),
            stackViewLabels.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            stackViewLabels.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            stackViewLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
