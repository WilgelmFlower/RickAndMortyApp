import UIKit

final class RickAndMortyCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: RickAndMortyCollectionViewCell.self)

    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10

        return image
    }()

    private let titleCharacter: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with imageURL: String, and title: String) {
        if let imageURL = URL(string: imageURL) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.titleCharacter.text = title
                    }
                }
            }
        }
    }

    private func setupLayout() {
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = UIColor(named: "cvBG")

        contentView.addSubview(imageView)
        contentView.addSubview(titleCharacter)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleCharacter.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60),

            titleCharacter.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleCharacter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleCharacter.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleCharacter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
