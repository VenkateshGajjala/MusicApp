

import UIKit
import MediaPlayer
class PlayMusicViewController: UIViewController {
    
    var selectedId = Int()
    var selectedSection  = Int()
    var selectedAlbums: [AlbumInfo] = []
     var songQuery: SongQuery = SongQuery()
    
    @IBOutlet weak var songStatusBtn: UIButton!
    
    @IBOutlet var songTitleLable: UILabel!
    
    @IBOutlet var pictureImage: UIImageView!
    let player = MPMusicPlayerController.systemMusicPlayer
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedId)
        selectedIdSongPlay(section: selectedSection, id: selectedId)

        // Do any additional setup after loading the view.
    }
    func setPictureImage(_ songId: NSNumber){
        let item: MPMediaItem = songQuery.getItem( songId: songId )
        //
        if  let imageSound: MPMediaItemArtwork = item.value( forProperty: MPMediaItemPropertyArtwork ) as? MPMediaItemArtwork {
           pictureImage.image = imageSound.image(at: CGSize(width: pictureImage.frame.size.width, height: pictureImage.frame.size.height))
            pictureImage.layer.cornerRadius = 5
           pictureImage.layer.masksToBounds = true
        }
    }
    
    func selectedIdSongPlay(section:Int, id:Int) {
        if selectedAlbums.count > section && 0 <= section {
//            if songselectedId = sele
            if selectedAlbums[section].songs.count > id && 0 <= id {
                let songId: NSNumber = selectedAlbums[section].songs[id].songId
                let mediaItems: MPMediaItem = songQuery.getItem( songId: songId )
                let mediaCollection = MPMediaItemCollection(items: [mediaItems])
                let player = MPMusicPlayerController.systemMusicPlayer
                player.setQueue(with: mediaCollection)
                player.play()
                setPictureImage(songId)
                songTitleLable.text = selectedAlbums[section].songs[id].songTitle
            } else if id < 0{
                selectedSection = section - 1
                selectedIdSongPlay(section: selectedSection, id: 0)
            }else{
                selectedSection = section + 1
                selectedIdSongPlay(section: selectedSection, id: 0)
            }
        }else if section < 0{
            selectedSection = 0
            selectedId = 0
        }else{
            selectedSection = selectedSection - 1
            selectedId = id - 1
        }
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        player.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func previousClicked(_ sender: Any) {
        player.pause()
        selectedId = selectedId - 1
        selectedIdSongPlay(section: selectedSection, id: selectedId)
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        player.pause()
        selectedId = selectedId + 1
        selectedIdSongPlay(section: selectedSection, id: selectedId)
        
    }
    
    @IBAction func playClicked(_ sender: Any) {
        if player.playbackState == .playing{
            player.pause()
            songStatusBtn.setImage(UIImage(named: "pause"), for: .normal)
            
        }else{
            player.play()
            songStatusBtn.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    @IBAction func pauseClicked(_ sender: Any) {
//        if player.playbackState == .playing{
//            player.pause()
//        }
    }
}
