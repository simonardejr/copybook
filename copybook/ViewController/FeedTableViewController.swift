//
//  FeedTableViewController.swift
//  copybook
//
//  Created by Simonarde Lima on 26/09/21.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    private let kBaseUrl = "https://jsonplaceholder.typicode.com"
    
    enum PostError: Error {
        case noDataAvailable
        case canNotProcessData
    }
    
    private var users = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // carregado em memória, mas não quer dizer que ela vai aparecer
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FeedTableViewCell.register(in: tableView)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
    }
    
    @objc private func onRefresh(_ sender: UIRefreshControl) {
        print("onRefresh")
        
        tableView.reloadSections([0], with: .automatic)
        
        sender.endRefreshing()
    }
    
    // vai ser apresentado para o usuário
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // imediatamente após a tela ser apresentada para o usuário
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        if let url = URL(string: "\(kBaseUrl)/posts") {
            let session = URLSession(configuration: URLSessionConfiguration.default,
                                     delegate: self,
                                     delegateQueue: OperationQueue.main)
            session.dataTask(with: url).resume()
        }

        if let urlUsers = URL(string: "\(kBaseUrl)/users") {
            let sessionUsers = URLSession(configuration: URLSessionConfiguration.default,
                                     delegate: self,
                                     delegateQueue: OperationQueue.main)
            sessionUsers.dataTask(with: urlUsers).resume()
        }
        */
        getPosts { [weak self] result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let posts):
                    self?.posts = posts
                }
        }
        
        getUsers { [weak self] result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let users):
                    self?.users = users
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.kReuseIdentifier, for: indexPath) as! FeedTableViewCell
        
        let post = posts[indexPath.row]
        
        for user in users {
            // print(user)
            if(user.id == post.userId) {
                cell.setup(with: post, andUser: user)
            }
        }

        return cell
    }
    
    func getPosts(completion: @escaping(Result<[Post], PostError>) -> Void) {
        guard let urlPost = URL(string: "\(kBaseUrl)/posts") else { fatalError() }
        let dataTask = URLSession.shared.dataTask(with: urlPost) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let posts = try? decoder.decode([Post].self, from: jsonData)
                completion(.success(posts!))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
    
    func getUsers(completion: @escaping(Result<[User], PostError>) -> Void) {
        guard let urlUser = URL(string: "\(kBaseUrl)/users") else { fatalError() }
        let dataTask = URLSession.shared.dataTask(with: urlUser) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let users = try? decoder.decode([User].self, from: jsonData)
                completion(.success(users!))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
    
}

/*
extension FeedTableViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let response = dataTask.response as? HTTPURLResponse,
           response.statusCode >= 200, response.statusCode < 300 {
            if let users = try? JSONDecoder().decode([User].self, from: data) {
                self.users = users
            }
            if let posts = try? JSONDecoder().decode([Post].self, from: data) {
                self.posts = posts
            }
        }
    }
}
*/
