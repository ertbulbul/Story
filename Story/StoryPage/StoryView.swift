import UIKit

class StoryView: UIView {
    
    lazy var storyCollectionView:  UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cV.register(StoryCell.self, forCellWithReuseIdentifier: StoryCell.identifier)
        cV.register(StoryCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "announceHeader")
        cV.backgroundColor = UIColor.clear
        cV.showsVerticalScrollIndicator = false
        return cV
    }()
    
    func setupView() {
        self.addSubview(storyCollectionView)

    }
    
    func setupAnchor(){
        
        _ = storyCollectionView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    
    
}



