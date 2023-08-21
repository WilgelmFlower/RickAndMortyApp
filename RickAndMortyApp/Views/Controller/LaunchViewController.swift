import UIKit

class LaunchScreenViewController: UIViewController {

    private let launchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        launchImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(launchImageView)

        NSLayoutConstraint.activate([
            launchImageView.topAnchor.constraint(equalTo: view.topAnchor),
            launchImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            launchImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            launchImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        launchImageView.image = UIImage(named: "launch")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.transitionToMainViewController()
        }
    }

    private func transitionToMainViewController() {
        let mainViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)

        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
}

