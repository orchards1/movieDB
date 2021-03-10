//
//  movieReview.swift
//  KitabisaTestingMovieDB
//
//  Created by Michael Louis on 10/03/21.
//

import Foundation

struct movieReview: Codable {
    let id, page: Int
    let results: [Review]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
