import UIKit

final class MenuViewController: UIViewController {
    
    private lazy var modalButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Modal", for: .normal)
        return button
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .red
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalButton.addTarget(self, action: #selector(handleModal), for: .touchUpInside)

        view.addSubview(modalButton)
        NSLayoutConstraint.activate([
            modalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func handleModal() {
        let viewModel = ModalViewModel()
        let vc = ModalViewController(viewModal: viewModel)
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true)
    }
}
