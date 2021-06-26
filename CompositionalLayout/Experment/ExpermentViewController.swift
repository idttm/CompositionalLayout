//
//  ExpermentViewController.swift
//  CompositionalLayout
//
//  Created by Andrew Cheberyako on 23.06.2021.
//

import UIKit

class ExpermentViewController: UIViewController {
    
    enum SectionData: Int, CaseIterable {
        case posterPhoto
        case moreInfoMovie
        case similarsMovies
    }
    
    
    enum Section: Int, CaseIterable {
        case posterPhoto
        case moreInfoMovie
        case similarsMovies
        var columnCount: Int {
            switch self {
            case .posterPhoto:
                return 1
            case .moreInfoMovie:
                return 1
            case . similarsMovies:
                return 1
            }
        }
    }
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupCollectionView()
        
    }
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .gray
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reusedId)
        collectionView.register(FootCell.self, forCellWithReuseIdentifier: FootCell.reusedId)
        collectionView.register(Similar.self, forCellWithReuseIdentifier: Similar.reusedId)
        setupDataSourse()
        reloadData()
        
    }
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvirnment) -> NSCollectionLayoutSection? in
            let section = Section(rawValue: sectionIndex)!
            switch section {
            
            case .posterPhoto:
                return self.posterSection()
            case .moreInfoMovie:
                return self.moreInfoSection()
            case .similarsMovies:
                return self.similarSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        layout.configuration = config
        return layout
    }
    
    func configure<T: SelfconfiguringCell>(cellType: T.Type, with intValue: Int, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reusedId, for: indexPath) as? T else {
            fatalError("Error\(cellType)")
        }
        return cell
    }
    
    private func setupDataSourse() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, intValue) -> UICollectionViewCell? in
            let section = Section(rawValue: indexPath.section)!
            switch section {
            
            case .posterPhoto:
                return self.configure(cellType: UserCell.self, with: intValue, for: indexPath)
            case .moreInfoMovie:
                return self.configure(cellType: FootCell.self, with: intValue, for: indexPath)
            case .similarsMovies:
                return self.configure(cellType: Similar.self, with: intValue, for: indexPath)
            }
        })
    }
    
    func reloadData() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.posterPhoto, .moreInfoMovie, .similarsMovies])
        snapshot.appendItems(Array(0..<1), toSection: .posterPhoto)
        snapshot.appendItems(Array(2...4), toSection: .moreInfoMovie)
        snapshot.appendItems(Array(5...15), toSection: .similarsMovies)
          dataSource.apply(snapshot, animatingDifferences: false)
    }
    
  
    
    private func posterSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        return section
    }
    
    private func moreInfoSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
       
        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        return section
    }
    
    private func similarSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        return section
        
    }
    
}

// MARK: - SwiftUI
import SwiftUI

struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let loginVC = ExpermentViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) -> ExpermentViewController {
            return loginVC
        }
        
        func updateUIViewController(_ uiViewController: LoginVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) {
            
        }
    }
}




