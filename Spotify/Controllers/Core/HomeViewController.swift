//
//  ViewController.swift
//  Spotify
//
//  Created by Erman Ufuk Demirci on 24.08.2022.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        
        fetchData()
    }
    
    private func fetchData() {
//        APICaller.shared.getNewReleases { result in
//            switch result {
//            case .success(let model):
//                break
//            case .failure(let error):
//                break
//            }
//        }
        
//        APICaller.shared.getFeaturedPlaylists { result in
//            switch result {
//            case .success(let model):
//                break
//            case .failure(let error):
//                break
//            }
//        }
        
//        APICaller.shared.getRecommendedGenres { result in
//            switch result {
//            case .success(let model):
//                let genreCount = model.genres.count
//                print(genreCount)
//            case .failure(_): break
//            }
//        }
        
//        APICaller.shared.getRecommendedGenres { result in
//            switch result {
//            case .success(let model):
//                let genres = model.genres
//                var seeds = Set<String>()
//                while seeds.count < 5 {
//                    if let random =  genres.randomElement(){
//                        seeds.insert(random)
//                    }
//                }
//
//                APICaller.shared.getRecommendations(genres: seeds) { _ in
//
//                }
//
//            case .failure(let error): break
//            }
//        }
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

