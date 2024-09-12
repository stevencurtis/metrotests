import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak private var myLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myLabel.text = "AA"
    }

    func configure(text: String) {
        myLabel.text = text
    }
    
}
