import Foundation

private struct APIEndpoints {
    static let characters = "https://rickandmortyapi.com/api/character"
}

final class APIManager {

    static let shared = APIManager()

    private func fetchData<T: Decodable>(from urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func getCharacters(completion: @escaping (Result<RickAndMortyModel, Error>) -> Void) {
        fetchData(from: APIEndpoints.characters, completion: completion)
    }

    func getLocation(url: String, completion: @escaping (Result<LocationRickAndMortyModel, Error>) -> Void) {
        fetchData(from: url, completion: completion)
    }

    func getEpisodes(urls: [String], completion: @escaping (Result<[EpisodesProperty], Error>) -> Void) {
        let group = DispatchGroup()
        var episodes: [EpisodesProperty] = []
        var errors: [Error] = []

        for url in urls {
            group.enter()
            fetchData(from: url) { (result: Result<EpisodesProperty, Error>) in
                switch result {
                case .success(let episode):
                    episodes.append(episode)
                case .failure(let error):
                    errors.append(error)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            if errors.isEmpty {
                completion(.success(episodes))
            } else {
                completion(.failure(errors[0]))
            }
        }
    }

}

enum NetworkError: Error {
    case invalidURL
    case noData
}
