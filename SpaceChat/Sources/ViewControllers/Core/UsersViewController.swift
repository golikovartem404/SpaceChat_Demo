//
//  UsersViewController.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UsersViewController: UIViewController {

    private let currentUser: MUser
    private var usersListener: ListenerRegistration?
    var users = [MUser]()
    var dataSource: UICollectionViewDiffableDataSource<Section, MUser>?

    enum Section: Int, CaseIterable {
        case users

        func description(usersCount: Int) -> String {
            switch self {
            case .users:
                return "\(usersCount) people nearby"
            }
        }
    }

    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }

    deinit {
        usersListener?.remove()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var usersCollection: UICollectionView = {
        let layout = createCompositionalLayout()
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collection.register(
            UserCollectionViewCell.self,
            forCellWithReuseIdentifier: UserCollectionViewCell.identifier
        )
        collection.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.identifier
        )
        collection.backgroundColor = .clear
        collection.delegate = self
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite()
        setupHierarchy()
        setupLayout()
        setupNavigationBar()
        createDataSource()
        usersListener = ListenerService.shared.usersObserve(users: users) { result in
            switch result {
            case .success(let users):
                self.users = users
                self.reloadData(with: nil)
            case .failure(let error):
                self.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
            }
        }
    }

    private func setupNavigationBar() {

        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .mainWhite()
        navigationController?.navigationBar.tintColor = .black

        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Log Out",
            style: .plain,
            target: self,
            action: #selector(signOut)
        )
    }

    private func setupHierarchy() {
        view.addSubview(usersCollection)
    }

    private func setupLayout() {
        usersCollection.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalTo(view)
        }
    }

}

//MARK: - Actions for buttons Extension

extension UsersViewController {
    @objc private func signOut() {
        let alertController = UIAlertController(
            title: nil,
            message: "Are you sure to sign out?",
            preferredStyle: .alert
        )
        let actionYes = UIAlertAction(
            title: "Sign Out",
            style: .destructive
        ) { _ in
            do {
                try Auth.auth().signOut()
                SceneDelegate.shared.changeViewcontroller(
                    viewController: AuthenticationViewController(),
                    animated: true,
                    animationOptions: .transitionFlipFromTop
                )
            } catch {
                print("Error while signing out: \(error.localizedDescription)")
            }
        }
        let actionNo = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        alertController.addAction(actionYes)
        alertController.addAction(actionNo)
        present(alertController, animated: true)
    }
}

// MARK: - Compositional Layout Setup

extension UsersViewController {

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, enviroment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unmnown section") }
            switch section {
            case .users:
                return self.createUsersSectionLayout()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        layout.configuration = config
        return layout
    }

    private func createUsersSectionLayout() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.6)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        let spacing: CGFloat = 15
        group.interItemSpacing = .fixed(15)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: 15,
            bottom: 0,
            trailing: 15
        )

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return sectionHeader
    }
}

// MARK: - Diffable DataSource Extension

extension UsersViewController {

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MUser>(collectionView: usersCollection, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard
                let section = Section(rawValue: indexPath.section)
            else {
                fatalError("Unmnown section")
            }
            switch section {
            case .users:
                return self.configure(
                    collection: collectionView,
                    cellType: UserCollectionViewCell.self,
                    with: user,
                    for: indexPath
                )
            }
        })
        dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeader.identifier,
                    for: indexPath
                ) as? SectionHeader
            else {
                fatalError("Cannot create a new section header")
            }
            guard
                let section = Section(rawValue: indexPath.section)
            else {
                fatalError("Unknowned section kind")
            }
            let items = self.dataSource?.snapshot().itemIdentifiers(inSection: .users)
            sectionHeader.cofigure(
                withText: section.description(usersCount: items?.count ?? 0),
                font: .systemFont(ofSize: 36, weight: .light),
                textColor: .black
            )
            return sectionHeader
        }
    }

    private func reloadData(with searchText: String?) {
        let filteredUsers = users.filter { user in
            user.contains(filter: searchText)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, MUser>()
        snapshot.appendSections([.users])
        snapshot.appendItems(filteredUsers, toSection: .users)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

}

// MARK: - UICollectionView Delegate Extension

extension UsersViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        let profileViewController = ProfileViewController(user: user)
        profileViewController.delegate = self
        present(profileViewController, animated: true)
    }

}

// MARK: - SearchBar Delegate

extension UsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}

extension UsersViewController: ShowAlertDelegate {

    func showAlert(title: String, message: String) {
        self.showAlert(withTitle: title, andMessage: message)
    }

}
