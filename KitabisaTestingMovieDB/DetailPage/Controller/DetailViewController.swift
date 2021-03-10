//
//  DetailViewController.swift
//  KitabisaTestingMovieDB
//
//  Created by Michael Louis on 09/03/21.
//

import UIKit
import CoreData
import SDWebImage
class DetailViewController: UIViewController {

    @IBAction func FavoriteButtonSelected(_ sender: Any) {
        if(favoriteButton.isSelected == true)
        {
            favoriteButton.isSelected = false
            let alert = UIAlertController(title: "Removed from Favorites", message: "This Movie has been deleted from favorite list", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
           
            deleteMovieFromCoreData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadFav"), object: nil)
        }
        else
        {
            favoriteButton.isSelected = true
            let alert = UIAlertController(title: "Added to Favorites", message: "This Movie has been Added to favorite list", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           
            present(alert, animated: true, completion: nil)
        
            let url = "https://image.tmdb.org/t/p/w500" + String(selectedMovie!.posterPath)
          
            let id = String(selectedMovie!.id)
            saveMovieToCoreData(id: id, name: selectedMovie!.title, releaseDate: selectedMovie!.releaseDate, description: selectedMovie!.overview, imageUrl: url)
        }
    }
    func deleteMovieFromCoreData()
    {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        managedContext.delete(currMovie!)
        
        do {
            try managedContext.save()
        } catch {
            // Do something... fatalerror
        }
    }
    func saveMovieToCoreData(id: String , name: String, releaseDate: String, description: String, imageUrl: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Movie",in: managedContext)!
        
        let movie = NSManagedObject(entity: entity,
                                  insertInto: managedContext)

        movie.setValue(name, forKey: "title")
        movie.setValue(id, forKey: "id")
        movie.setValue(description, forKey: "movieDescription")
        movie.setValue(releaseDate, forKey: "releaseDate")
        movie.setValue(imageUrl, forKey: "imageUrl")
        //4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
    
    @IBOutlet var movieDescription: UITextView!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var posterImage: UIImageView!
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var movieid : String = ""
    var selectedMovie : MovieDetail?
    var currMovie : Movie?
    var Reviews : [Review] = []
    var FavoriteMovies: [Movie] = []
    var isFav = false
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
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieDetailsFromID(id: movieid)
        fetchFavorites()
        setupTableView()
        
        
        // Do any additional setup after loading the view.
    }
    func checkIfFavorite()
    {
        for favMovie in FavoriteMovies
        {
            if(selectedMovie?.id == Int(favMovie.id!))
            {
                currMovie = favMovie
                isFav = true
            }
        }
        
        if(isFav == true)
        {
            favoriteButton.isSelected = true
        }
    }
    func setupPage()
    {
        movieTitle.text = selectedMovie?.title
        releaseDate.text = selectedMovie?.releaseDate
        movieDescription.text = selectedMovie?.overview
        
        let url = "https://image.tmdb.org/t/p/w500" + String(selectedMovie!.posterPath)
        posterImage.sd_setImage(with: URL(string: url), completed: nil)
        self.title = selectedMovie?.title
    }
    func setupTableView()
    {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    func fetchReviewsFromMovie()
    {
        let movieID = String(selectedMovie!.id)
        let url = "https://api.themoviedb.org/3/movie/\(movieID)/reviews?api_key=b99ab5bbd139525d4e1be36586c67d0a&language=en-US&page=1"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        let dataTask = defaultSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                
                guard let dataResponse = data,
                      error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
                do{
                    
                    let objectData = try JSONDecoder().decode(movieReview.self, from: dataResponse)
                    
                    for eachReviews in objectData.results
                    {
                        self.Reviews.append(eachReviews)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            
        }
        )
        dataTask.resume()
    }
    func fetchMovieDetailsFromID(id: String)
    {
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=b99ab5bbd139525d4e1be36586c67d0a&language=en-US"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        let dataTask = defaultSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                
                guard let dataResponse = data,
                      error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
                do{
                    
                    let objectData = try JSONDecoder().decode(MovieDetail.self, from: dataResponse)
                    
                    self.selectedMovie = objectData
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.fetchReviewsFromMovie()
                        self.setupPage()
                        self.checkIfFavorite()

                    }
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            
        }
        )
        dataTask.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DetailViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(Reviews.count == 0)
        {
            return 0
        }
        else
        {
            return Reviews.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reviewcell", for: indexPath) as! DetailTableViewCell
        let review = Reviews[indexPath.row] as Review
        var string1 = "A review by " + review.author
        cell.ReviewerNameLabel.text = string1
        cell.ReviewContent.text = review.content
        return cell
    }
    
    
}
