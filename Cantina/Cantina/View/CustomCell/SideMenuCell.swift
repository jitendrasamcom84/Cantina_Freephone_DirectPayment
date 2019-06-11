import UIKit

class SideMenuCell: UITableViewCell {
    
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var imgMenu: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
