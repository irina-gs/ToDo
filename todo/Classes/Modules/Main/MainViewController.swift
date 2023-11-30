//
//  MainViewController.swift
//  todo
//
//  Created by admin on 31.10.2023.
//

import UIKit

struct MainDataItem {
    let id: String
    let title: String
    let deadline: Date
    let isCompleted: Bool
}

final class MainViewController: ParentViewController {
    private var data: [MainDataItem] = []
    private var error: Error?
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
            section.interGroupSpacing = 16
            return section
        })
        
        newEntryButton.setTitle(L10n.Main.emptyButton, for: .normal)
        newEntryButton.isHidden = false

        Task {
            await getData()
        }
        reloadData()
    }
    
    @IBAction private func didTapNewEntryButton() {
        performSegue(withIdentifier: "new-item", sender: nil)
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
    
    private func getData() async {
        Task {
            do {
                let response = try await NetworkManager.shared.getTodos()
                data = response.map{
                    MainDataItem(id: $0.id, title: $0.title, deadline: $0.date, isCompleted: $0.isCompleted)
                }
                error = nil
            } catch let fetchError{
                error = fetchError
            }
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    private func reloadData() {
        if let error {
            let customError: EmptyViewController.CustomError = error is NetworkError ? .noConnection : .somethingWentWrong
            
            newEntryButton.isHidden = true
            emptyVC?.state = .empty
            emptyVC?.action = { [weak self] in
                Task {
                    await self?.getData()
                }
            }
        } else {
            newEntryButton.isHidden = true
            emptyVC?.state = .error(.somethingWentWrong)
            emptyVC?.action = { [weak self] in
                self?.performSegue(withIdentifier: "new-item", sender: nil)
            }
            emptyView.isHidden = !data.isEmpty
            if !data.isEmpty {
                newEntryButton.isHidden = false
                collectionView.reloadData()
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
        let selectedItemCell = data[indexPath.row]
        Task {
            do {
                let response = try await NetworkManager.shared.changeMark(id: selectedItemCell.id)
                await getData()
            } catch {
                let alertVC = UIAlertController(title: "Ошибка!", message: error.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
                present(alertVC, animated: true)
            }
        }
    }
}

extension MainViewController: NewItemViewControllerDelegate {
    func didSelect(_ vc: NewItemViewController, data: NewItemData) {
        Task {
            await getData()
        }
    }
}
