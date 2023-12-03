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
    let date: Date
    let isCompleted: Bool
}

final class MainViewController: ParentViewController {
    private var data: [MainDataItem] = []
    private var emptyVC: EmptyViewController?
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var emptyView: UIView!
    @IBOutlet private var newEntryButton: PrimaryButton!
    
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            section.interGroupSpacing = 16
            return section
        })
        
        emptyView.isHidden = true
        newEntryButton.setTitle(L10n.Main.emptyButton, for: .normal)

        reloadData()
    }
    
    private func segueNewItemVC() {
        performSegue(withIdentifier: "new-item", sender: nil)
    }
    
    @IBAction private func didTapNewEntryButton() {
        segueNewItemVC()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.destination {
        case let destination as EmptyViewController:
            emptyVC = destination
        case let destination as NewItemViewController:
            destination.delegate = self
        default:
            break
        }
    }
    
    private func reloadData() {
        Task {
            do {
                data = try await NetworkManager.shared.getTodos()
                
                DispatchQueue.main.async {
                    self.emptyView.isHidden = !self.data.isEmpty
                    self.newEntryButton.isHidden = self.data.isEmpty
                }
                
                if !data.isEmpty {
                    collectionView.reloadData()
                } else {
                    emptyVC?.state = .empty
                    emptyVC?.action = { [weak self] in
                        self?.segueNewItemVC()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.emptyView.isHidden = false
                    self.newEntryButton.isHidden = true
                }
                
                emptyVC?.state = .error(error)
                emptyVC?.action = { [weak self] in
                    self?.reloadData()
                }
            }
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

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = data[indexPath.row]
        Task {
            do {
                _ = try await NetworkManager.shared.changeMark(id: selectedItem.id)
                reloadData()
            } catch {
                DispatchQueue.main.async {
                    self.showAlertVC(massage: error.localizedDescription)
                }
            }
        }
    }
}

extension MainViewController: NewItemViewControllerDelegate {
    func didSelect(_ vc: NewItemViewController) {
        reloadData()
    }
}
