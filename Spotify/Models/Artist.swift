//
//  Artist.swift
//  Spotify
//
//  Created by Erman Ufuk Demirci on 24.08.2022.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
