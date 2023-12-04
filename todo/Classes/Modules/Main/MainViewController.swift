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
    private var selectedItem: MainDataItem?
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var newEntryButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (view as? StatefullView)?.delegate = self
        
        navigationItem.title = L10n.Main.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: nil)
        
        collectionView.register(UINib(nibName: "MainItemCell", bundle: nil), forCellWithReuseIdentifier: MainItemCell.reuseID)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(93))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            section.interGroupSpacing = 16
            return section
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
                (view as? StatefullView)?.state = .empty(error: error)
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
            
            cell.action = { [weak self] id in
                Task {
                    do {
                        _ = try await NetworkManager.shared.changeMark(id: id)
                        
                        self?.data[indexPath.row].isCompleted.toggle()
                        cell.setMark(isCompleted: self!.data[indexPath.row].isCompleted)
                    } catch {
                        DispatchQueue.main.async {
                            self?.showAlertVC(massage: error.localizedDescription)
                        }
                    }
                }
            }
            
            return cell
        }
        fatalError("\(#function) error in cell creation")
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedItem = data[indexPath.row]
        segueNewItemVC()
    }
}

extension MainViewController: NewItemViewControllerDelegate {
    func didSelect(_ vc: NewItemViewController) {
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
