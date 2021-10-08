//
//  FeedTableViewController.swift
//  copybook
//
//  Created by Simonarde Lima on 26/09/21.
//

import UIKit

class AlbumTableViewController: UITableViewController {
    
    private let kBaseUrl = "https://jsonplaceholder.typicode.com"
    
    enum PostError: Error {
        case noDataAvailable
        case canNotProcessData
    }
    
    var userId: Int = 0
    
    private var albums = [Album]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
//    required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//    }
    
//    init(userId: Int) {
//        self.userId = userId
//        super.init(nibName: nil, bundle: nil)
//        print("->>>")
//        print(self.userId)
//    }
    
    
    // carregado em memória, mas não quer dizer que ela vai aparecer
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // vai ser apresentado para o usuário
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // imediatamente após a tela ser apresentada para o usuário
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getAlbumFromUser(userId: self.userId) { [weak self] result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let albums):
                    self?.albums = albums
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        
        let album = albums[indexPath.row]
        
        cell.textLabel?.text = album.title
        
        return cell
    }

    func getAlbumFromUser(userId id: Int, completion: @escaping(Result<[Album], PostError>) -> Void) {
        print("\(kBaseUrl)/users/\(id)/albums")
        guard let urlUser = URL(string: "\(kBaseUrl)/users/\(id)/albums") else { fatalError() }
        let dataTask = URLSession.shared.dataTask(with: urlUser) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let albums = try? decoder.decode([Album].self, from: jsonData)
                completion(.success(albums!))
            } /*catch {
                completion(.failure(.canNotProcessData))
            }*/
        }
        dataTask.resume()
    }
    
}
