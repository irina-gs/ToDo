//
//  MainViewController.swift
//  todo
//
//  Created by admin on 31.10.2023.
//

import UIKit

struct MainDataItem {
    let title: String
    let deadline: String
}

final class MainViewController: ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.Main.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: nil)
        
        collectionView.register(UINib(nibName: "MainItemCell", bundle: nil), forCellWithReuseIdentifier: MainItemCell.reuseID)
        collectionView.allowsMultipleSelection = true
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(93))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        })
        
        reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.destination {
        case let destination as EmptyViewController:
            destination.state = .empty
            destination.action = { [weak self] in
                self?.performSegue(withIdentifier: "new-item", sender: nil)
            }
        case let destination as NewItemViewController:
            destination.delegate = self
        default:
            break
        }
    }
    
    private var data: [MainDataItem] = []
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var emptyView: UIView!
    
    private func reloadData() {
        emptyView.isHidden = !data.isEmpty
        if !data.isEmpty {
            collectionView.reloadData()
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainItemCell.reuseID, for: indexPath) as? MainItemCell {
            cell.setup(item: data[indexPath.row])
            return cell
        }
        fatalError("\(#function) error in cell creation")
    }
}

extension MainViewController: UICollectionViewDelegate {}

extension MainViewController: NewItemViewControllerDelegate {
    func didSelect(_ vc: NewItemViewController, data: NewItemData) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = L10n.Main.dateFormat
        
        self.data = [.init(title: data.title, deadline: dateFormatter.string(from: data.deadline))]
//        self.data.append(<#T##newElement: MainDataItem##MainDataItem#>)
        
        reloadData()
    }
}
