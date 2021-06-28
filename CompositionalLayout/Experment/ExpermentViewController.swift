//
//  ExpermentViewController.swift
//  CompositionalLayout
//
//  Created by Andrew Cheberyako on 23.06.2021.
//

import UIKit

struct Movie: Hashable {
    let id: String
    let title: String = "constant: 10constant: 10constant: 10constant: 10constant: 10constant: 10constant: 10constant: 10constant: 10constant: 10constant: 10"
    let description: String
    let rating: String
    let posterURL: URL
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}

class ExpermentViewController: UIViewController {
    
    var viewModel = MoviewTBVViewModel()
    
    enum SectionData: Int, CaseIterable {
        case posterPhoto
        case moreInfoMovie
        case similarsMovies
    }
    
    let movie: Movie = Movie(id: "", description: "Test test", rating: "4", posterURL: URL(string: "https://google.com")!)
    let similarMoveis: [Movie] = [Movie(id: "1", description: "Similar test 1", rating: "3", posterURL: URL(string: "https://google.com")!),
                                  Movie(id: "2", description: "Similar test 2 ", rating: "5", posterURL: URL(string: "https://google.com")!)]
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.getDataLayout { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.collectionView.reloadData()
            }
        }
    }
    //        viewModel.getDataLayout {
    //            [weak self] in
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
    ////                self?.viewModel.sectionData1()
    //                self?.collectionView.reloadData()
    //
    //            })
    //        }
    
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
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = Section(rawValue: indexPath.section)!
            switch section {
            case .posterPhoto:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterPhoto.reusedId, for: indexPath) as! PosterPhoto
                //                if item == item {
                if self.viewModel.sectionDataForPosterPhoto?.id == nil{
                    cell.posterPhoto.image = UIImage(systemName: "square.and.arrow.up")!
                } else {
                    cell.posterPhoto.setImage(secondPartURL: self.viewModel.sectionDataForPosterPhoto!.posterPath)
                }
                return cell
            case .title:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreInfoMovie.reusedId, for: indexPath) as! MoreInfoMovie
                if self.viewModel.sectionDataForMoreInfo?.id == nil  {
                    cell.label.text = "error you lose"
                } else {
                    cell.label.text = self.viewModel.sectionDataForMoreInfo?.title
                }
                return cell
            case .overview:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreInfoMovie.reusedId, for: indexPath) as! MoreInfoMovie
                if self.viewModel.sectionDataForMoreInfo?.id == nil  {
                    cell.label.text = "error "
                } else {
                    cell.label.text = self.viewModel.sectionDataForMoreInfo?.overview
                }
                return cell
            case .rating:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreInfoMovie.reusedId, for: indexPath) as! MoreInfoMovie
                if self.viewModel.sectionDataForMoreInfo?.id == nil  {
                    cell.label.text = "error "
                } else {
                    guard let rating = self.viewModel.sectionDataForMoreInfo?.rating else {return nil}
                    cell.label.text = String(rating)
                }
                return cell
            case .similarsMovies:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Similar.reusedId, for: indexPath) as! Similar
                if self.viewModel.sectionDataForSimilarMovies?.moviewSimilar[0].title == nil {
                    cell.label.text = self.movie.title
                } else {
                    cell.photoMovie.setImage(secondPartURL: (self.viewModel.sectionDataForSimilarMovies?.moviewSimilar[0].posterPath)!)
                    cell.label.text = self.viewModel.sectionDataForSimilarMovies?.moviewSimilar[0].title
                }
                return cell
                
            }
        })
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.posterPhoto, .title, .rating, .overview, .similarsMovies])
//        snapshot.appendItems([viewModel.sectionDataForPosterPhoto?.posterPath], toSection: .posterPhoto)
//        snapshot.appendItems([viewModel.sectionDataForMoreInfo?.title], toSection: .title)
//        snapshot.appendItems([viewModel.sectionDataForMoreInfo?.rating], toSection: .rating)
//        snapshot.appendItems([viewModel.sectionDataForMoreInfo?.overview], toSection: .overview)
        print(viewModel.sectionDataForPosterPhoto?.id,
              viewModel.sectionDataForMoreInfo?.id)
//        snapshot.appendItems([viewModel.sectionDataForSimilarMovies?.moviewSimilar.count], toSection: .similarsMovies)
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




enum Section: Int {
    case posterPhoto
    case title
    case overview
    case rating
    case similarsMovies
}

struct MovieInfo: Equatable {
    let id: String
    let description: String
}

class SimilarMoviesItem: Hashable {
    let moveis: [MovieInfo]
    
    init(similarMoviesInfo: [MovieInfo]) {
        moveis = similarMoviesInfo
    }
    
    func hash(into hasher: inout Hasher) {
        let cobmined = moveis.map { $0.id }.joined(separator: "")
        hasher.combine(cobmined)
    }
    
    static func == (lhs: SimilarMoviesItem, rhs: SimilarMoviesItem) -> Bool {
        lhs.moveis == rhs.moveis
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

