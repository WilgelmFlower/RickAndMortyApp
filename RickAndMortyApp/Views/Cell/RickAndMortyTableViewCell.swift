import UIKit

final class RickAndMortyTableViewCell: UITableViewCell {

    static let identifier = String(describing: RickAndMortyTableViewCell.self)

    private let stackViewLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalCentering

        return stack
    }()

    private let stackViewValues: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalCentering

        return stack
    }()

    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.text = "Species:"
        label.textColor = UIColor(named: "grayNormal")
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left

        return label
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Type:"
        label.textColor = UIColor(named: "grayNormal")
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left

        return label
    }()

    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender:"
        label.textColor = UIColor(named: "grayNormal")
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left

        return label
    }()


    private let speciesLabelValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right

        return label
    }()

    private let typeLabelValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right

        return label
    }()

    private let genderLabelValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with species: String, type: String, gender: String) {
        self.speciesLabelValue.text = species
        self.typeLabelValue.text = type
        self.genderLabelValue.text = gender
    }

    private func setupLayout() {

        contentView.backgroundColor = UIColor(named: "cvBG")

        stackViewLabels.translatesAutoresizingMaskIntoConstraints = false
        speciesLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false

        stackViewValues.translatesAutoresizingMaskIntoConstraints = false
        speciesLabelValue.translatesAutoresizingMaskIntoConstraints = false
        typeLabelValue.translatesAutoresizingMaskIntoConstraints = false
        genderLabelValue.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackViewLabels)
        stackViewLabels.addArrangedSubview(speciesLabel)
        stackViewLabels.addArrangedSubview(typeLabel)
        stackViewLabels.addArrangedSubview(genderLabel)

        contentView.addSubview(stackViewValues)

        stackViewValues.addArrangedSubview(speciesLabelValue)
        stackViewValues.addArrangedSubview(typeLabelValue)
        stackViewValues.addArrangedSubview(genderLabelValue)

        NSLayoutConstraint.activate([
            stackViewLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackViewLabels.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackViewLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            stackViewValues.topAnchor.constraint(equalTo: stackViewLabels.topAnchor),
            stackViewValues.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackViewValues.bottomAnchor.constraint(equalTo: stackViewLabels.bottomAnchor)
        ])
    }
}
