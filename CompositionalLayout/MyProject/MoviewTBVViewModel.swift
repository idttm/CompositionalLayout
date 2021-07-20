//
//  MoviewTBVViewModel.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 22.05.2021.
//

import UIKit

class MoviewTBVViewModel {
    private let networkManager = NetworkMoviesManager()
    var posterURLString: String = ""
    var similarMovies: [ResultSimilar] = []
    var sectionDataForMoreInfo: MoreTextInfo?

    func getDataLayout(completion: @escaping() -> Void) {
        let dg = DispatchGroup()
        dg.enter()
        networkManager.getDataTrending(page: 1, week: false) { [weak self] result in
            switch result {
            case .success(let data):
                self?.posterURLString = data.first?.posterPath  ?? ""
                self?.sectionDataForMoreInfo = MoreTextInfo(currentMoview: data)
            case .failure(let error):
                break
            }
            dg.leave()
        }

        dg.enter()
        networkManager.getDataSimilar(page: 1, query: "1726") { [weak self] result in
            switch result {
            case .success(let data):
                self?.similarMovies = data
            case .failure(let error):
                print("ERROR \(error.localizedDescription)")
                break
            }
            dg.leave()
        }

        dg.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
}
