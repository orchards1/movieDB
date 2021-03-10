//
//  FavoriteViewController.swift
//  KitabisaTestingMovieDB
//
//  Created by Michael Louis on 10/03/21.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var selectedMovie : Movie?
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: NSNotification.Name(rawValue: "loadFav"), object: nil)
        super.viewDidLoad()
        self.title = "Favorites"
        self.navigationItem.rightBarButtonItem = nil
        setupTableView()
        fetchFavorites()
        // Do any additional setup after loading the view.
    }
    @objc func reloadView()
    {
        fetchFavorites()
        tableView.reloadData()
    }
    var FavoriteMovies: [Movie] = []
    func fetchFavorites()
    {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<Movie>(entityName: "Movie")
        //3
        do {
            self.FavoriteMovies = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "favToDetail")
        {
            var vc = segue.destination as? DetailViewController
            vc?.movieid = (selectedMovie?.id)!
        }
    }
    func setupTableView()
    {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    
}
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "favcell", for: indexPath) as! TableViewCell
        
        cell.titleLabel.text = FavoriteMovies[indexPath.row].title
        cell.detailLabel.text = FavoriteMovies[indexPath.row].movieDescription
        cell.releaseDateLabel.text = FavoriteMovies[indexPath.row].releaseDate
        cell.movieImage.sd_setImage(with: URL(string: FavoriteMovies[indexPath.row].imageUrl!), completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = FavoriteMovies[indexPath.row]
        performSegue(withIdentifier: "favToDetail", sender: nil)
    }
}
