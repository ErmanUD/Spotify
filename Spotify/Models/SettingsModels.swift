//
//  SettingsModels.swift
//  Spotify
//
//  Created by Erman Ufuk Demirci on 28.08.2022.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> ()
}
