//
//  ExpermentViewController.swift
//  CompositionalLayout
//
//  Created by Andrew Cheberyako on 23.06.2021.
//

import UIKit
import Kingfisher

enum Section: Int {
    case posterPhoto
    case title
    case overview
    case rating
    case similarsMovies
}

class ExpermentViewController: UIViewController {
    
    var viewModel = MoviewTBVViewModel()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.getDataLayout { [weak self] in
                self?.reloadData()
        }
    }

    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(PosterPhoto.self, forCellWithReuseIdentifier: PosterPhoto.reusedId)
        collectionView.register(MoreInfoMovie.self, forCellWithReuseIdentifier: MoreInfoMovie.reusedId)
        collectionView.register(Similar.self, forCellWithReuseIdentifier: Similar.reusedId)
        setupDataSourse()
        reloadData()
    }

    private func createLayout() -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout { [unowned self] (sectionIndex, layoutEnvirnment) -> NSCollectionLayoutSection? in
            let section = Section(rawValue: sectionIndex)!
            switch section {
            case .posterPhoto:
                return self.posterSection()
            case .similarsMovies:
                return self.similarSection()
            case .title, .rating, .overview:
                return self.moreInfoSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func setupDataSourse() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let section = Section(rawValue: indexPath.section)!
            switch section {
            case .posterPhoto:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterPhoto.reusedId, for: indexPath) as! PosterPhoto
                cell.posterPhoto.setImage(secondPartURL: self.viewModel.posterURLString)
                return cell
            case .title:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreInfoMovie.reusedId, for: indexPath) as! MoreInfoMovie
                cell.label.text = self.viewModel.sectionDataForMoreInfo?.title
                return cell
            case .overview:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreInfoMovie.reusedId, for: indexPath) as! MoreInfoMovie
                cell.label.text = self.viewModel.sectionDataForMoreInfo?.overview
                return cell
            case .rating:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreInfoMovie.reusedId, for: indexPath) as! MoreInfoMovie
                guard let rating = self.viewModel.sectionDataForMoreInfo?.rating else { return cell }
                cell.label.text = String(rating)
                return cell
            case .similarsMovies:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Similar.reusedId, for: indexPath) as! Similar
                cell.photoMovie.setImage(secondPartURL: self.viewModel.similarMovies[indexPath.row].posterPath)
                cell.label.text = self.viewModel.similarMovies[indexPath.row].title
                return cell
            }
        })
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.posterPhoto, .title, .rating, .overview, .similarsMovies])
        snapshot.appendItems([viewModel.posterURLString], toSection: .posterPhoto)
        snapshot.appendItems([viewModel.sectionDataForMoreInfo?.title], toSection: .title)
        snapshot.appendItems([viewModel.sectionDataForMoreInfo?.rating], toSection: .rating)
        snapshot.appendItems([viewModel.sectionDataForMoreInfo?.overview], toSection: .overview)
        snapshot.appendItems(viewModel.similarMovies, toSection: .similarsMovies)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func posterSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(600))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        return section
    }
    
    private func moreInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: NSCollectionLayoutSpacing.fixed(5), top: NSCollectionLayoutSpacing.fixed(5), trailing: NSCollectionLayoutSpacing.fixed(5), bottom: NSCollectionLayoutSpacing.fixed(5))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func similarSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 10)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .fractionalWidth(0.6))
       
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        return section
        
    }
}

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(secondPartURL: String) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + secondPartURL) else { return }
        kf.setImage(with: url)
        
    }
}

