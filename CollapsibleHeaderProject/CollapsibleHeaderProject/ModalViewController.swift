final class ModalViewModel {
    let data = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
}

import UIKit

final class ModalViewController: UIViewController {
    private static let headerHeight: CGFloat = 150
    private var previousHeader: CGFloat = 150
    private let viewModal: ModalViewModel
    private lazy var modalTable = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        return table
    }()
    
    private lazy var header = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(modalTable)
        view.addSubview(header)
        view.bringSubviewToFront(header)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: Self.headerHeight),
            modalTable.topAnchor.constraint(equalTo: view.topAnchor),
            modalTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modalTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modalTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.standardAppearance.backgroundColor = .blue
        modalTable.contentInset = UIEdgeInsets(top: Self.headerHeight - self.view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
        
        modalTable.contentOffset = CGPoint(x: 0, y: -Self.headerHeight)
        modalTable.delegate = self
    }
    
    var isProgrammaticScroll = false
    
    init(viewModal: ModalViewModel) {
        self.viewModal = viewModal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .clear
        self.view = view
    }
}

extension ModalViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = viewModal.data[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModal.data.count
    }
    
//    private var scrollDirectionUp = true
}

extension ModalViewController: UITableViewDelegate {
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        previousHeader = offsetY
//    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//        if scrollView.contentOffset.y > previousHeader {
//            // moving up
//            let offsetY: CGFloat = -55
//            let heightAdjustment = header.bounds.height - modalTable.contentInset.top + view.safeAreaInsets.top
//            let scaleFactor = (abs(offsetY) + heightAdjustment) / view.bounds.height
//            let translation = CGAffineTransform(translationX: 0, y: -(offsetY + modalTable.contentInset.top + view.safeAreaInsets.top))
//            print(offsetY)
//            self.modalTable.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
//            
//        } else {
//            // moving down
//            
//            self.modalTable.setContentOffset(CGPoint(x: 0, y: -(Self.headerHeight - self.view.safeAreaInsets.top)), animated: true)
//
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isProgrammaticScroll else {
            isProgrammaticScroll = true
            return }
                let offsetY = scrollView.contentOffset.y

        if offsetY > -(self.navigationController?.navigationBar.frame.height ?? -55) {
            header.isHidden = true
            navigationController?.setNavigationBarHidden(false, animated: false)
            return
        }

        header.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        let translation = CGAffineTransform(translationX: 0, y: -(offsetY + modalTable.contentInset.top + view.safeAreaInsets.top))
        header.transform = translation
    }
}
