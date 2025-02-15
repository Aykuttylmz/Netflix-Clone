//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Aykut Türkyılmaz on 25.11.2024.
//

import UIKit

enum Section : Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController{
    
    private var randomTrendingMovie : Title?
    private var headerView : HeroHeader?
    
    let sectionTitles : [String] = ["Trending Movies", "Trending Tv","Popular", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        headerView = HeroHeader(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        
        configureNavBar()
        configureHeroHeader()
        
        
    }
    
    private func configureHeroHeader() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case.success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavBar() {
        if let image = UIImage(named: "netflixLogo") {
            let resizedImage = image.resized(to: CGSize(width: 20, height: 30))
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: resizedImage?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: nil)
        }
        
    
        
        let personImage = UIImage(systemName: "person")
        let playImage = UIImage(systemName: "play.rectangle")
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: personImage?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed), style: .done, target: self, action: nil),
            UIBarButtonItem(image: playImage?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    func fetchTitles(for section: Section, completion: @escaping ([Title]) -> Void) {
        
        switch section {
        case .TrendingMovies:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    completion(titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion([])
                }
            }
        case .TrendingTv:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    completion(titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion([])
                }
            }
        case .Popular:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let titles):
                    completion(titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion([])
                }
            }
        case .TopRated:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let titles):
                    completion(titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion([])
                }
            }
        case .Upcoming:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    completion(titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion([])
                }
            }
        }
    }

    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
            
        case Section.TrendingMovies.rawValue:
            
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.TrendingTv.rawValue:
            
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.Popular.rawValue:
            
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
            
        case Section.TopRated.rawValue:
            
            APICaller.shared.getTopRatedMovies {result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
            
        case Section.Upcoming.rawValue:
            
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.localizedCapitalized

    }
    
}

extension HomeViewController : CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}



