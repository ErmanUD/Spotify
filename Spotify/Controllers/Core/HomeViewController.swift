//
//  ViewController.swift
//  Spotify
//
//  Created by Erman Ufuk Demirci on 24.08.2022.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [NewReleasesCellViewModel])
    case recommendedTracks(viewModels: [NewReleasesCellViewModel])
}

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
//    private let spinner: UIActivityIndicatorView = {
//        let spinner = UIActivityIndicatorView()
//        spinner.tintColor = .label
//        spinner.hidesWhenStopped = true
//
//        return spinner
//    }()

    private var sections = [BrowseSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        configureCollectionView()
//        view.addSubview(spinner)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleasesCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistsResponse?
        var recommendations: RecommendationsResponse?
        
        // New Releases
        APICaller.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        

        // Featured Playlists
        APICaller.shared.getFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        // Recomended Tracks
        
        APICaller.shared.getRecommendedGenres { result in
        
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
                    defer {
                        group.leave()
                    }
                    switch recommendedResult {
                    case .success(let model):
                        recommendations = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items,
                  let tracks = recommendations?.tracks
            else {
                fatalError("Models are nil")
            }
            
            self.configureModels(newAlbums: newAlbums,
                                 plalists: playlists,
                                 tracks: tracks)
        }
    }
    
    private func configureModels(newAlbums: [Album], plalists: [Playlist], tracks: [AudioTrack]) {
     
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(name: $0.name,
                                            artworkURL: URL(string: $0.images.first?.url ?? ""),
                                            numberOfTracks: $0.total_tracks,
                                            artistName: $0.artists.first?.name ?? "unknown")
        })))
        sections.append(.featuredPlaylists(viewModels: []))
        sections.append(.recommendedTracks(viewModels: []))
        collectionView.reloadData()
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier,
                                                                for: indexPath) as? NewReleasesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell

        case .featuredPlaylists(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                                                                for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.backgroundColor = .blue
            return cell
            
        case .recommendedTracks(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                                                                for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .orange
            return cell
        }
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
       switch section {
       case 0:
           // ITEM
           let item = NSCollectionLayoutItem(
               layoutSize: NSCollectionLayoutSize(
                   widthDimension: .fractionalWidth(1),
                   heightDimension: .fractionalHeight(1)
               )
           )
           
           item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
           
           // GROUP
           
           let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .fractionalHeight(1)),
            subitem: item,
            count: 3)
           
           let horizontalGroup = NSCollectionLayoutGroup.horizontal(
               layoutSize: NSCollectionLayoutSize(
                   widthDimension: .fractionalWidth(0.9),
                   heightDimension: .absolute(450)
               ),
               subitem: verticalGroup,
               count: 1)
           
           // SECTION
           let section = NSCollectionLayoutSection(group: horizontalGroup)
           section.orthogonalScrollingBehavior = .groupPaging
           
           return section
           
       case 1:
           // ITEM
           let item1 = NSCollectionLayoutItem(
               layoutSize: NSCollectionLayoutSize(
                   widthDimension: .fractionalWidth(1),
                   heightDimension: .fractionalHeight(0.2)
               )
           )
           
           let item2 = NSCollectionLayoutItem(
               layoutSize: NSCollectionLayoutSize(
                   widthDimension: .fractionalWidth(1),
                   heightDimension: .fractionalHeight(0.6)
               )
           )
           
           let item3 = NSCollectionLayoutItem(
               layoutSize: NSCollectionLayoutSize(
                   widthDimension: .fractionalWidth(1),
                   heightDimension: .fractionalHeight(0.2)
               )
           )
           
           item1.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
           item2.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
           item3.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

           // GROUP
           let verticalGroup = NSCollectionLayoutGroup.vertical(
               layoutSize: NSCollectionLayoutSize(
                   widthDimension: .fractionalWidth(1),
                   heightDimension: .fractionalHeight(1)),
               subitems: [item1, item2, item3]
           )
           
           let horizontalGroup = NSCollectionLayoutGroup.horizontal(
               layoutSize: NSCollectionLayoutSize(
                   widthDimension: .fractionalWidth(0.9),
                   heightDimension: .absolute(360)
               ),
               subitem: verticalGroup,
               count: 1)
           
           // SECTION
           let section = NSCollectionLayoutSection(group: horizontalGroup)
           section.orthogonalScrollingBehavior = .groupPaging
           
           return section
           
       case 2:
           // ITEM
           let item = NSCollectionLayoutItem(
               layoutSize: NSCollectionLayoutSize(
                   widthDimension: .fractionalWidth(1),
                   heightDimension: .fractionalHeight(1)
               )
           )
           
           item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

           // GROUP
           let verticalGroup = NSCollectionLayoutGroup.vertical(
               layoutSize: NSCollectionLayoutSize(
                   widthDimension: .fractionalWidth(1),
                   heightDimension: .absolute(80)
               ),
               subitem: item,
               count: 1
           )
           
           // SECTION
           let section = NSCollectionLayoutSection(group: verticalGroup)
           
           return section
           
       default:
           // ITEM
           let item = NSCollectionLayoutItem(
               layoutSize: NSCollectionLayoutSize(
                   widthDimension: .fractionalWidth(1),
                   heightDimension: .fractionalHeight(1)
               )
           )
           
           item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2 )

           // GROUP
           let group = NSCollectionLayoutGroup.horizontal(
               layoutSize: NSCollectionLayoutSize(
                   widthDimension: .fractionalWidth(1),
                   heightDimension: .fractionalHeight(0.3)
               ),
               subitem: item,
               count: 2
           )
           
           // SECTION
           let section = NSCollectionLayoutSection(group: group)
           section.orthogonalScrollingBehavior = .continuous
           
           return section
       }
   }
}
