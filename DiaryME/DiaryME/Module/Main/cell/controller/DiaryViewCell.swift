//
//  DiaryViewCell.swift
//  DiaryME
//
//  Created by Sittisak Teanpanom on 3/8/2564 BE.
//

import UIKit

class DiaryViewCell: UITableViewCell {

    @IBOutlet var diaryName: UILabel!
    
    @IBOutlet var imageShow: UIImageView!
    @IBOutlet var diaryTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUIDiaryCell(name:String,time:String,image:UIImage) {
        diaryName.text = name
        diaryTime.text = time
        imageShow.image = image
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
