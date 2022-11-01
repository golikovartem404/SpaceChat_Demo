//
//  ChatListViewController.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import UIKit
import FirebaseFirestore

class ChatListViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case waitingChats, activeChats

        func description() -> String {
            switch self {
            case .waitingChats:
                return "Waiting chats"
            case .activeChats:
                return "Active chats"
            }
        }
    }

    var activeChats = [MChat]()
    var waitingChats = [MChat]()
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?

    private let currentUser: MUser

    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?

    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
    }
    
    private lazy var chatCollection: UICollectionView = {
        let layout = createCompositionalLayout()
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collection.register(
            WaitingChatCollectionViewCell.self,
            forCellWithReuseIdentifier: WaitingChatCollectionViewCell.identifier
        )
        collection.register(
            ActiveChatCollectionViewCell.self,
            forCellWithReuseIdentifier: ActiveChatCollectionViewCell.identifier
        )
        collection.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.identifier
        )

        collection.delegate = self
        collection.backgroundColor = .clear
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite()
        setupHierarchy()
        setupLayout()
        setupNavigationBar()
        createDataSource()
        reloadData()
        waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats, completion: { result in
            switch result {
            case .success(let chats):
                if self.waitingChats != [], self.waitingChats.count <= chats.count {
                    let chatRequestView = ChatRequestViewController(chat: chats.last!)
                    chatRequestView.delegate = self
                    self.present(chatRequestView, animated: true)
                }
                self.waitingChats = chats
                self.reloadData()
            case .failure(let error):
                self.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
            }
        })
        activeChatsListener = ListenerService.shared.activeChatsObserve(chats: activeChats, completion: { result in
            switch result {
            case .success(let chats):
                self.activeChats = chats
                self.reloadData()
            case .failure(let error):
                self.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
            }
        })
    }

    private func setupNavigationBar() {

        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .mainWhite()

        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }

    private func setupHierarchy() {
        view.addSubview(chatCollection)
    }

    private func setupLayout() {
        chatCollection.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalTo(view)
        }
    }
}

// MARK: - Compositional Layout Extension

extension ChatListViewController {

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, enviroment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unmnown section") }
            switch section {
            case .activeChats:
                return self.createActiveChats()
            case .waitingChats:
                return self.createWaitingChats()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        layout.configuration = config
        return layout
    }

    private func createWaitingChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(88),
            heightDimension: .absolute(88)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: 20,
            bottom: 0,
            trailing: 20
        )
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }

    private func createActiveChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(78)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: 20,
            bottom: 0,
            trailing: 20
        )
        section.interGroupSpacing = 8
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

extension ChatListViewController {

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: chatCollection, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unmnown section") }
            switch section {
            case .activeChats:
                return self.configure(collection: collectionView,
                                      cellType: ActiveChatCollectionViewCell.self,
                                      with: chat,
                                      for: indexPath)
            case .waitingChats:
                return self.configure(collection: collectionView,
                                      cellType: WaitingChatCollectionViewCell.self,
                                      with: chat,
                                      for: indexPath)
            }
        })
        dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as? SectionHeader
            else {
                fatalError("Cannot create a new section header")
            }
            guard
                let section = Section(rawValue: indexPath.section)
            else {
                fatalError("Unknowned section kind")
            }
            sectionHeader.cofigure(
                withText: section.description(),
                font: .laoSangamMN20(),
                textColor: .headerTextColor()
            )
            return sectionHeader
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        snapshot.appendItems(activeChats, toSection: .activeChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

}

extension ChatListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .waitingChats:
            let chatRequestVC = ChatRequestViewController(chat: chat)
            chatRequestVC.delegate = self
            self.present(chatRequestVC, animated: true)
        case .activeChats:
            print(indexPath)
        }
    }

}

// MARK: - SearchBar Delegate

extension ChatListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

// MARK: - WaitingChatsNavigationDelegate Extension

extension ChatListViewController: WaitingChatsNavigationDelegate {

    func removeWaitingChat(chat: MChat) {
        FirestoreService.shared.deleteWaitingChat(chat: chat) { result in
            switch result {
            case .success():
                self.showAlert(withTitle: "Success", andMessage: "Your chat with \(chat.friendUsername) was deleted")
            case .failure(let error):
                self.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
            }
        }
    }

    func changeToActive(chat: MChat) {
        FirestoreService.shared.changeChatToActive(chat: chat) { result in
            switch result {
            case .success():
                self.showAlert(withTitle: "Success", andMessage: "Have a nice chat with \(chat.friendUsername)!")
            case .failure(let error):
                self.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
            }
        }
    }
}
