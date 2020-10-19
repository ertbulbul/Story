import UIKit
import Gemini
import AVKit
import AVFoundation

protocol StoryCellDelegate: class {
    func snapsFinished(storyIndex: Int)
    func prevStoryTapped(storyIndex: Int)
}


class StoryCell: GeminiCell, SegmentedProgressBarDelegate {
   
    weak var cellDelegate: StoryCellDelegate?
    static let identifier = "cell"
    private var profile: Profile!
    private var storyIndex: Int!
    private var firstInit = true
    private var touchLocation = CGPoint(x: 0, y: 0)
    private var enteredMove = false
    private var fromStoryTransition = false
    public var safeAreaTop: CGFloat!
   
    
    lazy var view: UIView = {
        let uiview = UIView()
        return uiview
    }()
    
    lazy var segmentedProgressBar: SegmentedProgressBar = {
        var progressBar = SegmentedProgressBar(numberOfSegments: 1, duration: 5, topPoint: 50)
        progressBar.frame = CGRect(x: 15, y: 100, width: self.frame.width - 30, height: 4)
        progressBar.topColor = UIColor.white
        progressBar.bottomColor = UIColor.white.withAlphaComponent(0.25)
        progressBar.padding = 2
        progressBar.delegate = self
        return progressBar
    }()
    
    lazy var snapImageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.clipsToBounds = true
        myImageView.backgroundColor = .gray
        return myImageView

    }()
    
    lazy var profileImageView: UIImageView = {
        let pp = UIImageView()
        pp.layer.borderWidth = 0.4
        pp.backgroundColor = .clear
        pp.layer.borderColor = UIColor.black.cgColor
        pp.clipsToBounds = true
        pp.layer.masksToBounds = true
        pp.layer.cornerRadius = Constants.profilePictureSize / 2.0
        return pp
    }()
    
    
    var headersVisible = true {
        didSet {
            UIView.animate(withDuration: 0.3) {
                [self.segmentedProgressBar, self.profileImageView].forEach {
                    $0!.alpha = 1.0 - $0!.alpha
                }
            }
            segmentedProgressBar.isPaused = !segmentedProgressBar.isPaused

        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        profile?.snapVisitedCount += 1
    }
    
    public func setupLayout(safeAreaTop: CGFloat){
        self.safeAreaTop = safeAreaTop
        setupView()
        setupAnchor()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            touchLocation = currentPoint
            headersVisible.toggle()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            enteredMove = true
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            headersVisible.toggle()
            
            if(touchLocation.x > frame.width / 2 && currentPoint.x > frame.width / 2 && !enteredMove ){
                
                if(profile!.snapVisitedCount + 1 < (profile?.stories!.count)!){
                    moveNextStory(withSkip: true)
                }else{
                    //TODO transition to next cell
                    cellDelegate?.snapsFinished(storyIndex: storyIndex!)
                }
                
            }else if(touchLocation.x < frame.width / 2 && currentPoint.x < frame.width / 2 && !enteredMove){
                if(profile!.snapVisitedCount - 1 >= 0){
                    movePreviousStory()
                }else{
                    //TODO transition to previous cell
                    cellDelegate?.prevStoryTapped(storyIndex: storyIndex!)
                }
            }
        }
        enteredMove = false
    }
    
    func moveNextStory(withSkip: Bool = false){
        profile!.snapVisitedCount += 1
        snapImageView.downloaded(from: profile!.stories![profile!.snapVisitedCount].url!)
        fromStoryTransition = true
        if(withSkip) {
            segmentedProgressBar.skip()
        }
        
    }

    func movePreviousStory(){
        profile!.snapVisitedCount -= 1
        snapImageView.downloaded(from: profile!.stories![profile!.snapVisitedCount].url!)
        fromStoryTransition = true
        segmentedProgressBar.rewind()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubviewToFront(profileImageView)
        self.bringSubviewToFront(segmentedProgressBar)
        profileImageView.alpha = 1
        segmentedProgressBar.alpha = 1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(profile: Profile, storyIndex: Int) {
        
        self.profile = profile
        self.storyIndex = storyIndex
        profileImageView.downloaded(from: profile.userPp!, contentMode: .scaleToFill)
        snapImageView.downloaded(from: profile.stories![profile.snapVisitedCount].url!)
        setProgressBar(numberOfSegments: profile.stories!.count, currentIndex: profile.snapVisitedCount)
                      
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        snapImageView.image = nil
    }
    
    func setProgressBar(numberOfSegments: Int, duration: Double = 5, currentIndex: Int = 0) {
        segmentedProgressBar.removeFromSuperview()
        segmentedProgressBar = SegmentedProgressBar(numberOfSegments: numberOfSegments, duration: duration, topPoint: safeAreaTop)
        segmentedProgressBar.frame = CGRect(x: 15, y: 15, width: self.frame.width - 30, height: 4)
        segmentedProgressBar.topColor = UIColor.white
        segmentedProgressBar.bottomColor = UIColor.white.withAlphaComponent(0.25)
        segmentedProgressBar.delegate = self
        segmentedProgressBar.startAnimation()
        self.addSubview(segmentedProgressBar)
        _ = segmentedProgressBar.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        var i = 0
        while currentIndex > i{
            fromStoryTransition = true
            segmentedProgressBar.skip()
            i += 1
        }
    }
    
    func setupView() {
        self.addSubview(view)
        self.addSubview(segmentedProgressBar)
        self.addSubview(profileImageView)
        self.addSubview(snapImageView)
        
    }

    
    func setupAnchor() {
        
        _ = view.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = profileImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: safeAreaTop + Constants.profilePictureSize / 2 , leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: Constants.profilePictureSize, heightConstant: Constants.profilePictureSize)
        
        _ = snapImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = segmentedProgressBar.anchor(self.view.safeAreaLayoutGuide.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 200, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)

        
    }
    
    func segmentedProgressBarChangedIndex(index: Int) {
        if(profile!.snapVisitedCount < (profile?.stories!.count)!){
            if profile!.snapVisitedCount + 1 == profile?.stories?.count {
                //TODO move next cell
            }else{
                if(!fromStoryTransition){
                    moveNextStory()
                    fromStoryTransition = false
                }else{
                    fromStoryTransition = false
                }
            }
        }else{
            
        }
    }
    
    func segmentedProgressBarFinished() {
        cellDelegate?.snapsFinished(storyIndex: storyIndex!)
        prepareForReuse()
        
    }
    

}


