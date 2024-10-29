//
//  MatchedDataTableViewCell.swift
//  JSONParsingDemo
//
//  Created by Yashwant Kumar on 29/10/24.
//

import UIKit

class MatchedDataTableViewCell: UITableViewCell {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func configure(with data: MatchedData) {
        companyNameLabel.text = "Compnay: \(data.companyName)"
        latLabel.text = "Lat: \(data.lat)"
        lngLabel.text = "lng: \(data.lng)"
        titleLabel.text = " Title: \(data.title)"
        bodyLabel.text = "Body: \(data.body)"
    }

}
