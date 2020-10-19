import UIKit
import AVFoundation
import AnimatedCollectionViewLayout
import ObjectMapper
import Gemini

class StoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var profilesModel:ProfilesModel?
    var currentSelected:Int = 0
    
    
    lazy var storyCollectionView:  GeminiCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv =  GeminiCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.delegate   = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.backgroundColor = .black
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(StoryCell.self, forCellWithReuseIdentifier:StoryCell.identifier)
        cv.isPagingEnabled = true
        cv.isPrefetchingEnabled = false
        cv.gemini
            .cubeAnimation()
            .cubeDegree(90)
        return cv
    }()
    
    private let dismissGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .down
        return gesture
    }()
    
    
    
    @objc func didSwipeDown(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(storyCollectionView)
        
        _ = storyCollectionView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: UIScreen.main.bounds.width, heightConstant: UIScreen.main.bounds.height)
        
        dismissGesture.addTarget(self, action: #selector(didSwipeDown(_:)))
        self.storyCollectionView.addGestureRecognizer(dismissGesture)
        
    }
    
    init(profilesModel: ProfilesModel,currentSelected: Int) {
        self.profilesModel = profilesModel
        self.currentSelected = currentSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (profilesModel?.profiles.count)!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCell.identifier, for: indexPath) as! StoryCell
        cell.configure(profile: (profilesModel?.profiles[indexPath.row])!, storyIndex: indexPath.row)
        cell.cellDelegate = self
        self.storyCollectionView.animateCell(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return UIScreen.main.bounds.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.storyCollectionView.animateVisibleCells()
    }
    
    



}

extension StoryViewController: StoryCellDelegate {
    
    //TODO: Cell transition.
    func snapsFinished(storyIndex: Int) {
        if(storyIndex + 1 == profilesModel?.profiles.count){
            dismiss(animated: true, completion: nil)
        }else {
//            let i = IndexPath(item: 1, section: 0)
//            storyCollectionView.reloadData()
//            storyCollectionView.scrollToItem(at: i, at: .right, animated: true)
//
//            storyCollectionView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width*CGFloat((storyIndex + 1)), y: 0.0), animated: true)
//
//            self.storyCollectionView.setNeedsLayout()
            //storyCollectionView.reloadData()
            print("Selected")
            //storyCollectionView.scrollToItem(at: IndexPath.init(row: storyIndex, section: 0), at: .right, animated: false)
            
            let rect = self.storyCollectionView.layoutAttributesForItem(at: IndexPath(row: storyIndex + 1, section: 0))?.frame
            storyCollectionView.animateVisibleCells()
            self.storyCollectionView.scrollRectToVisible(rect!, animated: true)
            
            storyCollectionView.reloadData()
                
        }
    }
}
