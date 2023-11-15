//
//  MainViewController.swift
//  todo
//
//  Created by admin on 31.10.2023.
//

import UIKit

struct MainDataItem {
    let title: String
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
                self?.data = [.init(title: "1")]
                self?.reloadData()
            }
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
