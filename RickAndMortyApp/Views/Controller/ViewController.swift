import UIKit

final class ViewController: UIViewController {

    var characters = [RickAndMortyModel]()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true

        return indicator
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 156, height: 202)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(RickAndMortyCollectionViewCell.self
                                , forCellWithReuseIdentifier: RickAndMortyCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mainBG")
        configureNavigationBar()
        setupLayout()

        collectionView.delegate = self
        collectionView.dataSource = self
        loadingIndicator.startAnimating()
        
        APIManager.shared.getCharacters { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let characters):
                self.characters.append(characters)
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                switch error {
                case NetworkError.invalidURL:
                    print("Invalid URL")
                case NetworkError.noData:
                    print("No data recieved")
                default:
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func configureNavigationBar() {
        self.title = "Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }

    private func setupLayout() {

        view.addSubview(loadingIndicator)
        view.addSubview(collectionView)

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.first?.results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RickAndMortyCollectionViewCell.identifier, for: indexPath) as? RickAndMortyCollectionViewCell else { return UICollectionViewCell() }
        let characterImages = characters[indexPath.section].results[indexPath.row].image
        let characterNames = characters[indexPath.section].results[indexPath.row].name
        cell.configure(with: characterImages, and: characterNames)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCharacter = characters[indexPath.section].results[indexPath.row]
        let selectedLocation = selectedCharacter.location.url
        let selectedEpisodes = selectedCharacter.episode
        let detailViewController = DetailViewController()
        detailViewController.characters = characters
        detailViewController.makeRequestCharacterLocation(with: selectedLocation)
        detailViewController.makeRequestCharacterEpisodes(with: selectedEpisodes)
        detailViewController.configure(with: selectedCharacter.image, characterName: selectedCharacter.name, characterStatus: selectedCharacter.status.rawValue)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ViewController: UICollectionViewDelegate {}
