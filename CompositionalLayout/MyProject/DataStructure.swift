//
//  SectionDataStruct.swift
//  CompositionalLayout
//
//  Created by Andrew Cheberyako on 26.06.2021.
//

import Foundation

struct PosterPhotoData: Hashable {
    static func == (lhs: PosterPhotoData, rhs: PosterPhotoData) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    var posterPath: String
    
    init?(currentMoview: [DataResult]) {
        self.posterPath = currentMoview[0].posterPath
        self.id = currentMoview[0].id
        
    }

}

struct MoreTextInfo: Hashable {
    
    static func == (lhs: MoreTextInfo, rhs: MoreTextInfo) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var id: Int
    var title: String
    var rating: Double
    var overview: String
    
    init?(currentMoview: [DataResult]) {
        self.id = currentMoview[0].id + 1
        self.title = currentMoview[0].title
        self.rating = currentMoview[0].voteAverage
        self.overview = currentMoview[0].overview
    }
}

struct SimilarMovies: Hashable {
    static func == (lhs: SimilarMovies, rhs: SimilarMovies) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var id = UUID()
    var moviewSimilar: [ResultSimilar]
    
    init?(similarData: [ResultSimilar]) {
        self.moviewSimilar = similarData
    }
    

    
}





