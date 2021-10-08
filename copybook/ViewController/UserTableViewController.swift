//
//  FeedTableViewController.swift
//  copybook
//
//  Created by Simonarde Lima on 26/09/21.
//

import UIKit

class UserTableViewController: UITableViewController {
    
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
    
    var userId: Int = 1

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
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        self.userId = user.id
        
        //performSegue(withIdentifier: "showalbum", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showalbum") {
                let showAlbumViewController: AlbumTableViewController = segue.destination as! AlbumTableViewController
                
            showAlbumViewController.userId = self.userId
        }
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
            } /*catch {
                completion(.failure(.canNotProcessData))
            }*/
        }
        dataTask.resume()
    }
    
}
