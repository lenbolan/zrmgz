//
//  HomeTableViewCell.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/5/2.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var lbIncome: UILabel!
    @IBOutlet weak var lbExpend: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(data: HomeCellData) {
        imgIcon.image = UIImage(systemName: data.icon)
        lbTitle.text = data.title
        lbSubTitle.text = data.subTitle
        lbIncome.text = "\(data.income)"
        lbExpend.text = "\(data.expend)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
