//
//  ViewController.swift
//  KitabisaTestingMovieDB
//
//  Created by Michael Louis on 09/03/21.
//

import UIKit
import SDWebImage
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var apiKey = "b99ab5bbd139525d4e1be36586c67d0a"
    var selectedMovie : Result?
    var arrayURL : [String] = []
    var arrayMovies : [[Result]] = [[]]
    var popularmovie : [Result] = []
    var nowplayingmovie : [Result] = []
    var upcomingmovie : [Result] = []
    var topratingmovie : [Result] = []
    var popularImage : [UIImage] = []
    var nowplayingImage : [UIImage] = []
    var upcomingImage: [UIImage] = []
    var topratingImage: [UIImage] = []
    
    var selectedIndex = 0
    
    @IBAction func favoriteButtonDidTapped(_ sender: Any) {
        performSegue(withIdentifier: "toFav", sender: nil)
    }
    
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedIndex = 0
            tableView.reloadData()
        case 1:
            selectedIndex = 1
            tableView.reloadData()
        case 2:
            selectedIndex = 2
            tableView.reloadData()
        case 3:
            selectedIndex = 3
            tableView.reloadData()
        default:
            break
        }
    }
    @IBOutlet var segmentedControl: UISegmentedControl!
    var number = 10
    func isnumbergreaterthan10(number: Int) throws -> Bool
    {
        if(number>10)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupURL()
    {
        //Popular - Upcoming - Top Rated - Now Playing
        arrayURL.append("https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1")
        
        arrayURL.append("https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=en-US&page=1")
        arrayURL.append("https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=en-US&page=1")
        arrayURL.append( "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=1")
        arrayMovies.append(popularmovie)
        arrayMovies.append(upcomingmovie)
        arrayMovies.append(topratingmovie)
        arrayMovies.append(nowplayingmovie)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TheMovieDB"
        setupURL()
        setupTableView()
        fetchMovies()
    }
    func fetchMovies()
    {
        for i in 0...3
        {
            let request = NSMutableURLRequest(url: NSURL(string: arrayURL[i])! as URL,
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
                        
                        let objectData = try JSONDecoder().decode(TheMovieDB.self, from: dataResponse)
                        
                        for eachmovie in objectData.results
                        {
                            self.arrayMovies[i].append(eachmovie)
                            
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
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetail")
        {
            var vc = segue.destination as! DetailViewController
            vc.movieid = String(selectedMovie!.id)
        }
    }
}


extension ViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(selectedIndex == 0)
        {
            return arrayMovies[0].count
        }
        else if(selectedIndex == 1)
        {
            return arrayMovies[1].count
        }
        else if(selectedIndex == 2)
        {
            return arrayMovies[2].count
        }
        else
        {
            return arrayMovies[3].count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "homecell", for: indexPath) as! TableViewCell
        let eachmovie : [Result]
        if(selectedIndex == 0)
        {
            eachmovie = arrayMovies[0]
        }
        else if(selectedIndex == 1)
        {
            eachmovie = arrayMovies[1]
        }
        else if(selectedIndex == 2)
        {
            eachmovie = arrayMovies[2]
        }
        else
        {
            eachmovie = arrayMovies[3]
        }
        
        cell.titleLabel.text = eachmovie[indexPath.row].title
        cell.releaseDateLabel.text = eachmovie[indexPath.row].releaseDate
        cell.detailLabel.text = eachmovie[indexPath.row].overview
        cell.movieImage.image = nil
        let url = "https://image.tmdb.org/t/p/w500" + String(eachmovie[indexPath.row].posterPath)
        cell.movieImage.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "kucing") )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedIndex == 0)
        {
            selectedMovie = arrayMovies[0][indexPath.row]
            performSegue(withIdentifier: "toDetail", sender: nil)
        }
        else if(selectedIndex == 1)
        {
            selectedMovie = arrayMovies[1][indexPath.row]
            performSegue(withIdentifier: "toDetail", sender: nil)
        }
        else if(selectedIndex == 2)
        {
            selectedMovie = arrayMovies[2][indexPath.row]
            performSegue(withIdentifier: "toDetail", sender: nil)
        }
        else
        {
            selectedMovie = arrayMovies[3][indexPath.row]
            performSegue(withIdentifier: "toDetail", sender: nil)
        }
    }
}
extension UIImageView {

 public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        
        if self.image == nil{
              self.image = PlaceHolderImage
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }}
