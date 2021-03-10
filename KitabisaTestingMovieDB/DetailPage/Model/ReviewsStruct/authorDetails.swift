//
//  authorDetails.swift
//  KitabisaTestingMovieDB
//
//  Created by Michael Louis on 10/03/21.
//

import Foundation

struct AuthorDetails: Codable {
    let name, username: String
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}
