//
//  MainViewController.swift
//  todo
//
//  Created by admin on 31.10.2023.
//

import UIKit

struct MainDataItem: Decodable {
    let id: String
    let title: String
    let description: String
    let date: Date
    var isCompleted: Bool
}

final class MainViewController: ParentViewController {
    private var data: [MainDataItem] = []
    private var sections: [(date: Date, items: [MainDataItem])] = []
    private var selectedItem: MainDataItem?
    private var selectedDate: Date? {
        didSet {
            collectionView.reloadSections(IndexSet(integer: 1))
        }
    }

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var newEntryButton: PrimaryButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        (view as? StatefullView)?.delegate = self

        navigationItem.title = L10n.Main.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: #selector(didTapProfileButton))

        collectionView.register(MainDateCell.self, forCellWithReuseIdentifier: MainDateCell.reuseID)
        collectionView.register(UINib(nibName: "MainItemCell", bundle: nil), forCellWithReuseIdentifier: MainItemCell.reuseID)
        collectionView.allowsMultipleSelection = true
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            switch section {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .absolute(32))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 8
                section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
                return section
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(93))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                section.interGroupSpacing = 16
                return section
            }
        })

        newEntryButton.setTitle(L10n.Main.emptyButton, for: .normal)
        newEntryButton.isHidden = true

        reloadData()
    }

    private func segueNewItemVC() {
        performSegue(withIdentifier: "new-item", sender: nil)
    }

    @IBAction private func didTapNewEntryButton() {
        segueNewItemVC()
    }

    @objc
    private func didTapProfileButton() {
        performSegue(withIdentifier: "profile", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.destination {
        case let destination as NewItemViewController:
            destination.delegate = self
            destination.selectedItem = selectedItem
            selectedItem = nil
        default:
            break
        }
    }

    private func reloadData() {
        Task {
            do {
                (view as? StatefullView)?.state = .loading

                data = try await NetworkManager.shared.getTodos()

                sections = data
                    .reduce(into: [(date: Date, items: [MainDataItem])]()) { partialResult, item in
                        if let index = partialResult.firstIndex(where: { $0.date.withoutTimeStamp == item.date.withoutTimeStamp }) {
                            partialResult[index].items.append(item)
                        } else {
                            partialResult.append((date: item.date, items: [item]))
                        }
                    }
                    .sorted(by: { $0.date <= $1.date })

                DispatchQueue.main.async {
                    self.newEntryButton.isHidden = self.data.isEmpty
                }

                if !data.isEmpty {
                    (view as? StatefullView)?.state = .data
                    collectionView.reloadData()
                } else {
                    (view as? StatefullView)?.state = .empty()
                }
            } catch {
                DispatchQueue.main.async {
                    self.newEntryButton.isHidden = true
                }

                if (error as NSError).code == 401 {
                    logOutAccount()
                } else {
                    (view as? StatefullView)?.state = .empty(error: error)
                }
            }
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        2
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sections.count
        default:
            if let selectedDate {
                return sections.first(where: { $0.date == selectedDate })?.items.count ?? 0
            }
            return data.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainDateCell.reuseID, for: indexPath) as? MainDateCell {
                let dateCell = sections[indexPath.row].date
                if DateFormatter.year.string(from: dateCell) == DateFormatter.year.string(from: Date()) {
                    cell.setup(title: DateFormatter.dMMM.string(from: dateCell))
                } else {
                    cell.setup(title: DateFormatter.dMMMyyyy.string(from: dateCell))
                }
                return cell
            }
        default:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainItemCell.reuseID, for: indexPath) as? MainItemCell {
                let item: MainDataItem?
                if let selectedDate {
                    item = sections.first(where: { $0.date == selectedDate })?.items[indexPath.row]
                } else {
                    item = data[indexPath.row]
                }

                if let item {
                    cell.setup(item: item)

                    cell.action = { [weak self] itemId in
                        Task {
                            do {
                                _ = try await NetworkManager.shared.changeMark(id: itemId)

                                if let index = self?.data.firstIndex(where: { $0.id == item.id }) {
                                    self?.data[index].isCompleted.toggle()

                                    guard let itemIsCompleted = self?.data[index].isCompleted else {
                                        return
                                    }

                                    DispatchQueue.main.async {
                                        cell.setMark(isCompleted: itemIsCompleted)
                                    }
                                }

                                guard let data = self?.data else {
                                    return
                                }

                                self?.sections = (data
                                    .reduce(into: [(date: Date, items: [MainDataItem])]()) { partialResult, item in
                                        if let index = partialResult.firstIndex(where: { $0.date.withoutTimeStamp == item.date.withoutTimeStamp }) {
                                            partialResult[index].items.append(item)
                                        } else {
                                            partialResult.append((date: item.date, items: [item]))
                                        }
                                    }
                                    .sorted(by: { $0.date <= $1.date }))

                            } catch {
                                DispatchQueue.main.async {
                                    self?.showSnackBar()
                                }
                            }
                        }
                    }
                }
                return cell
            }
        }
        fatalError("\(#function) error in cell creation")
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let pathes = (0 ..< collectionView.numberOfItems(inSection: 0)).map { IndexPath(row: $0, section: 0) }
            pathes.forEach { path in
                if path != indexPath {
                    collectionView.deselectItem(at: path, animated: true)
                }
            }
            selectedDate = sections[indexPath.row].date
        default:
            collectionView.deselectItem(at: indexPath, animated: true)

            let item: MainDataItem?
            if let selectedDate {
                item = sections.first(where: { $0.date == selectedDate })?.items[indexPath.row]
            } else {
                item = data[indexPath.row]
            }

            if let item {
                selectedItem = item
                segueNewItemVC()
            }
        }
    }

    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedDate = nil
        default:
            break
        }
    }
}

extension MainViewController: NewItemViewControllerDelegate {
    func didSelect(_: NewItemViewController) {
        selectedDate = nil
        reloadData()
    }
}

extension MainViewController: StatefullViewDelegate {
    func statefullViewReloadData(_: StatefullView) {
        reloadData()
    }

    func statefullViewDidTapEmptyButton(_: StatefullView) {
        segueNewItemVC()
    }

    func statefullView(_: StatefullView, addChild controller: UIViewController) {
        addChild(controller)
    }

    func statefullView(_: StatefullView, didMoveToParent controller: UIViewController) {
        controller.didMove(toParent: self)
    }
}
