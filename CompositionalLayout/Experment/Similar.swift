//
//  Similar.swift
//  CompositionalLayout
//
//  Created by Andrew Cheberyako on 25.06.2021.
//

import UIKit

class Similar: UICollectionViewCell, SelfconfiguringCell {
    
    static var reusedId: String = "SimilarCell"
    func configure(with intValue: Int) {
        print("123")
    }
    let friendImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.purple
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupConstrains() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendImageView.backgroundColor = .green
        addSubview(friendImageView)
        friendImageView.frame = self.bounds
        backgroundColor = .green
    }
}

