//
//  FeedTableViewController.swift
//  copybook
//
//  Created by Simonarde Lima on 26/09/21.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    private let kBaseUrl = "https://jsonplaceholder.typicode.com"
    
    private var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }

    // carregado em memória, mas não quer dizer que ela vai aparecer
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FeedTableViewCell.register(in: tableView)
    }
    
    // vai ser apresentado para o usuário
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // imediatamente após a tela ser apresentada para o usuário
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let url = URL(string: "\(kBaseUrl)/posts") {
            let session = URLSession(configuration: URLSessionConfiguration.default,
                                     delegate: self,
                                     delegateQueue: OperationQueue.main)
            session.dataTask(with: url).resume()
            
            if let urlUsers = URL(string: "\(kBaseUrl)/users") {
                let sessionUsers = URLSession(configuration: URLSessionConfiguration.default,
                                         delegate: self,
                                         delegateQueue: OperationQueue.main)
                sessionUsers.dataTask(with: urlUsers).resume()
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.kReuseIdentifier, for: indexPath) as! FeedTableViewCell
        
        var userIndex = 1
        let post = posts[indexPath.row]
        if(post.userId == 0) {
            userIndex = 1
        } else {
            userIndex = post.userId
        }
        let user = users[userIndex]
        
        cell.setup(with: post, andUser: user)
        
        return cell
    }
    
}

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
