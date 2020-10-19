import UIKit
import ObjectMapper

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView?
    private var profilesModel: ProfilesModel?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        guard let myCollection = collectionView else {
            return
        }
        
        getStories()
        
        view.addSubview(myCollection)
        
        
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 150).integral
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (profilesModel?.profiles.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configure(with: (profilesModel?.profiles[indexPath.row].userPp)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async { [self] in
            let storyViewController = StoryViewController.init(profilesModel: profilesModel!, currentSelected: 0)
            storyViewController.modalPresentationStyle = .fullScreen
            self.present(storyViewController, animated: true, completion: nil)
            
        }
    }
    
    func getStories() {
        
        if let path = Bundle.main.path(forResource: "story", ofType: "json") {
            do {
                let text = try String(contentsOfFile: path, encoding: .utf8)
                profilesModel = Mapper<ProfilesModel>().map(JSONString: text)
            } catch {
                   // handle error
            }
        }
    }
}
