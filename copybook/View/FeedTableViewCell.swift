//
//  FeedTableViewCell.swift
//  copybook
//
//  Created by Simonarde Lima on 26/09/21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    static let kReuseIdentifier = "FeedTableViewCellWithImage"
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var givenName: UILabel!
    
    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var postText: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var likes: UILabel!
    
    @IBOutlet weak var comments: UILabel!
    
    @IBAction func onPostOptions(_ sender: UIButton) {
    }
    
    @IBAction func onLike(_ sender: UIButton) {
    }
    
    @IBAction func onComment(_ sender: UIButton) {
    }
    
    @IBAction func onShare(_ sender: UIButton) {
    }
    
    static func register(in tableView: UITableView) {
        let xib = UINib(nibName: "FeedTableViewCell", bundle: Bundle.main)
        tableView.register(xib, forCellReuseIdentifier: kReuseIdentifier)
        //tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: kReuseIdentifier)
    }
    
    func setup(with post: Post?, andUser user: User?) {
        profilePicture.image = UIImage(data: try! Data(contentsOf: URL(string: "http://lorempixel.com.br/100/100")!))
        postImage.image = UIImage(data: try! Data(contentsOf: URL(string: "http://lorempixel.com.br/600/450")!))
        givenName?.text = user?.name
        postText?.text = post?.body
        postDate?.text = "quarta-feira, 10 de setembro de 2021"
        likes?.text = "\(Int.random(in: 0..<100)) likes"
        comments?.text = "\(Int.random(in: 0..<20)) comentários"
        
    }
    
}
