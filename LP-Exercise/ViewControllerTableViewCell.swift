

import UIKit

class ViewControllerTableViewCell: UITableViewCell {
    
    //Labels and outlets of TableView
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var newPrice: UILabel!
    @IBOutlet weak var availableColors: UILabel!
    
    //Need this to perform
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //Set row selected (Not used)
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
