

import UIKit
import MediaPlayer
import AVFoundation
class MusicListViewController: UIViewController,MPMediaPickerControllerDelegate, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var musicTableView: UITableView!
    let myTableView: UITableView = UITableView( frame: CGRect.zero, style: .grouped )

    var albums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Music Library Songs"
        
        if #available(iOS 9.3, *) {
            MPMediaLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    self.albums = self.songQuery.get(songCategory: "")
                    DispatchQueue.main.async {
                        self.musicTableView.delegate = self
                        self.musicTableView.dataSource  = self
                        self.musicTableView.register(MusicPlayerCellCollectionViewCell.self, forCellReuseIdentifier: "MusicPlayerCellCollectionViewCell")
                        self.musicTableView?.reloadData()
                    }
                } else {
                    self.displayMediaLibraryError()
                }
            }
        } else {
            // Fallback on earlier versions
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayMediaLibraryError() {
        
        var error: String = ""
        if #available(iOS 9.3, *) {
            switch MPMediaLibrary.authorizationStatus() {
            case .restricted:
                error = "Media library access restricted by corporate or parental settings"
            case .denied:
                error = "Media library access denied by user"
            default:
                error = "Unknown error"
            }
        } else {
            // Fallback on earlier versions
        }
        
        let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }))
        present(controller, animated: true, completion: nil)
    }
    
    //MARK:- TABLE VIEW DELEGATE AND DATA SOURCE METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return albums.count
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int  {
        
        return albums[section].songs.count
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath:IndexPath ) -> UITableViewCell {
        
        let cell = musicTableView.dequeueReusableCell(
            withIdentifier: "MusicPlayerCell",
            for: indexPath) as! MusicPlayerCellCollectionViewCell
        cell.labelMusicTitle?.text = albums[indexPath.section].songs[indexPath.row].songTitle
        cell.labelMusicDescription?.text = albums[indexPath.section].songs[indexPath.row].artistName
        let songId: NSNumber = albums[indexPath.section].songs[indexPath.row].songId
        let item: MPMediaItem = songQuery.getItem( songId: songId )
//
        if  let imageSound: MPMediaItemArtwork = item.value( forProperty: MPMediaItemPropertyArtwork ) as? MPMediaItemArtwork {
            cell.imageMusic?.image = imageSound.image(at: CGSize(width: cell.imageMusic.frame.size.width, height: cell.imageMusic.frame.size.height))
            cell.imageMusic.layer.cornerRadius = 25
            cell.imageMusic.layer.masksToBounds = true
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return albums[section].albumTitle
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let mediaItems = MPMediaQuery.songs().items
        let dest = self.storyboard!.instantiateViewController(withIdentifier: "PlayMusicViewController") as! PlayMusicViewController
        dest.selectedId = indexPath.row
        dest.selectedSection = indexPath.section
        dest.selectedAlbums = albums
        self.navigationController?.pushViewController(dest, animated: true)
    }
}
