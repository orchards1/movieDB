//
//  theMovieDB.swift
//  KitabisaTestingMovieDB
//
//  Created by Michael Louis on 09/03/21.
//

import Foundation

struct TheMovieDB: Codable {
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
