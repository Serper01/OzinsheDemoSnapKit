//
//  MovieProtocol.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 03.03.2024.
//

import Foundation

protocol MovieProtocol {
    func movieDidSelect(movie: Movie)
    func genreDidSelect(genreId: Int, genreName: String)
    func ageCategoryDidSelect(categoryAgeId: Int)
}
