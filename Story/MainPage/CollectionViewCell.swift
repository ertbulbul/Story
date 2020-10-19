
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "cell"
    
    private let imageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.clipsToBounds = true
        myImageView.contentMode = .center
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
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with url:String) {
        imageView.downloaded(from: url, contentMode: .scaleToFill)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}
