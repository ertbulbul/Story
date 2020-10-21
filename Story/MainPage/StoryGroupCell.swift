import UIKit
import Alamofire
import AlamofireImage

class StoryGroupCell: UICollectionViewCell {
    
    static let identifier = "cell"
    
    lazy var profileImageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.clipsToBounds = true
        myImageView.contentMode = .scaleAspectFill
        myImageView.layer.masksToBounds = true
        myImageView.layer.cornerRadius = 150.0 / 2.0
        myImageView.backgroundColor = .blue
        myImageView.layer.borderWidth = 2
        myImageView.layer.borderColor = CGColor.init(red: 255, green: 0, blue: 0, alpha: 0.7)
        return myImageView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        contentView.addSubview(profileImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = contentView.bounds
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with url:String) {
        
        setImageWithAlamofireImage(imageView: profileImageView, urlString: url)
        
    }
    
    
    func setImageWithAlamofireImage(imageView: UIImageView, urlString: String){
        if let imageUrl = URL(string: urlString) {
            imageView.af.setImage(withURL: imageUrl)
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
    
    
    
}
