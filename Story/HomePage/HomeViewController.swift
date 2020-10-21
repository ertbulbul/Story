import UIKit
import ObjectMapper

class HomeViewController: UIViewController {
    
    private var storyGroupsCollectionView: UICollectionView!
    private var profilesModel: ProfilesModel?
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        
        getStories()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Constants.storyPpSize, height: Constants.storyPpSize)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        storyGroupsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        storyGroupsCollectionView?.showsHorizontalScrollIndicator = false
        storyGroupsCollectionView?.delegate = self
        storyGroupsCollectionView.dataSource = self
        storyGroupsCollectionView?.backgroundColor = .white
        storyGroupsCollectionView?.register(StoryGroupCell.self, forCellWithReuseIdentifier: StoryGroupCell.identifier)
        
        guard let myCollection = storyGroupsCollectionView else {
            return
        }
        
        
        view.addSubview(myCollection)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        storyGroupsCollectionView.reloadData()
        storyGroupsCollectionView.setNeedsLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        storyGroupsCollectionView?.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 150).integral
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (profilesModel?.profiles.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryGroupCell.identifier, for: indexPath) as! StoryGroupCell
        cell.configure(with: (profilesModel?.profiles[indexPath.row].userPp)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async { [self] in
            let storyViewController = StoryViewController.init(profilesModel: profilesModel!, currentSelected: indexPath.row)
            storyViewController.modalPresentationStyle = .fullScreen
            self.present(storyViewController, animated: true, completion: nil)
            
        }
    }
    
   
}

