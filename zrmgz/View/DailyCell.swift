//
//  DailyCell.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/5/3.
//

import UIKit

class DailyCell: UITableViewCell {

    @IBOutlet weak var lbSort: UILabel!
    @IBOutlet weak var lbNum: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    var account: Account?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(data: Account) {
        account = data
        lbSort.text = "\(account!.sortName)"
        lbNum.text = "\(account!.num)"
        if account?.type == 2 {
            lbNum.textColor = .red
        } else {
            lbNum.textColor = .green
        }
        lbDate.text = "\(account!.year).\(account!.month).\(account!.day)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
