import UIKit

final class DetailViewController: UIViewController {

    var characters = [RickAndMortyModel]()
    var locations = [LocationRickAndMortyModel]()
    var episodes = [EpisodesProperty]()
    let headerTitles = ["Info", "Origin", "Episodes"]

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true

        return indicator
    }()

    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 16

        return image
    }()

    private let titleCharacter: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22)

        return label
    }()

    private let statusTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)

        return label
    }()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = UIColor(named: "mainBG")
        table.separatorColor = .clear
        table.register(RickAndMortyTableViewCell.self,
                       forCellReuseIdentifier: RickAndMortyTableViewCell.identifier)
        table.register(OriginCellTableView.self,
                       forCellReuseIdentifier: OriginCellTableView.identifier)
        table.register(EpisodesTableViewCell.self,
                       forCellReuseIdentifier: EpisodesTableViewCell.identifier)

        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = UIColor(named: "mainBG")
        setupLayout()
    }

    func configure(with image: String, characterName: String, characterStatus: String) {
        if let imageURL = URL(string: image) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
        self.titleCharacter.text = characterName
        self.statusTitle.text = characterStatus
        switch characterStatus {
        case "Alive":
            self.statusTitle.textColor = .green
        case "Dead":
            self.statusTitle.textColor = .red
        case "unknown":
            self.statusTitle.textColor = .gray
        default:
            self.statusTitle.textColor = .white
        }
    }

    func makeRequestCharacterLocation(with URL: String) {
        APIManager.shared.getLocation(url: URL) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let location):
                self.locations = [location]
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.tableView.reloadData()
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

    func makeRequestCharacterEpisodes(with URL: [String]) {
        APIManager.shared.getEpisodes(urls: URL) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let episodes):
                self.episodes = episodes
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.tableView.reloadData()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func setupLayout() {

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleCharacter.translatesAutoresizingMaskIntoConstraints = false
        statusTitle.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(loadingIndicator)
        view.addSubview(imageView)
        view.addSubview(titleCharacter)
        view.addSubview(statusTitle)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            imageView.bottomAnchor.constraint(equalTo: titleCharacter.topAnchor, constant: -24),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.2),

            titleCharacter.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            titleCharacter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 118),
            titleCharacter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -118),
            titleCharacter.bottomAnchor.constraint(equalTo: statusTitle.topAnchor, constant: -8),

            statusTitle.topAnchor.constraint(equalTo: titleCharacter.bottomAnchor, constant: 8),
            statusTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 160),
            statusTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -160),
            statusTitle.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -24),

            tableView.topAnchor.constraint(equalTo: statusTitle.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension DetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return locations.count
        case 2:
            return episodes.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RickAndMortyTableViewCell.identifier, for: indexPath) as? RickAndMortyTableViewCell else { return UITableViewCell() }
            if let selectedCharacter = characters.first?.results.first {
                cell.configure(with: selectedCharacter.species.rawValue, type: selectedCharacter.type.isEmpty ? "Unknown Type" : selectedCharacter.type, gender: selectedCharacter.gender.rawValue)
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OriginCellTableView.identifier, for: indexPath) as? OriginCellTableView else { return UITableViewCell() }
            let selectedLocation = locations[indexPath.row]
            cell.configure(with: selectedLocation.name, location: selectedLocation.type)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodesTableViewCell.identifier, for: indexPath) as? EpisodesTableViewCell else { return UITableViewCell() }
            let selectedEpisode = episodes[indexPath.row]
            cell.configure(with: selectedEpisode.name, episodeNumber: selectedEpisode.episode, episodeDate: selectedEpisode.airDate)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension DetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return headerTitles[0]
        case 1:
            return headerTitles[1]
        case 2:
            return headerTitles[2]
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 124
        case 1:
            return 100
        case 2:
            return 86
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
