//
//  SourcesTableViewCell.swift
//  SimpleNews
//
//  Created by okky pribadi on 28/03/20.
//  Copyright © 2020 okky pribadi. All rights reserved.
//

import UIKit

class SourcesTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
