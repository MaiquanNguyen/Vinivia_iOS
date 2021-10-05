//
//  EventListCell.swift
//  Covid App
//
//  Created by Baboon on 05/10/2021.
//

import UIKit
import Kingfisher

class EventListCell: UITableViewCell {

    @IBOutlet private weak var eventName: UILabel!
    @IBOutlet private weak var eventCover: UIImageView!
    @IBOutlet private weak var eventStartDate: UILabel!
    @IBOutlet private weak var eventStartTime: UILabel!
    @IBOutlet private weak var eventEndDate: UILabel!
    @IBOutlet private weak var eventEndTime: UILabel!
    
    var scanEventHandle: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayEvent(_ event: Event) {
        eventName.text = event.name ?? ""
        if let image = event.logo, let url = URL(string: image) {
            eventCover.kf.setImage(with: url)
        } else {
            
        }
        eventStartDate.text = event.startDateString
        eventStartTime.text = event.startTimeString
        eventEndDate.text = event.endDateString
        eventEndTime.text = event.endTimeString
    }
    
}

extension EventListCell {
    @IBAction private func scanAction() {
        if let closure = self.scanEventHandle {
            closure()
        }
    }
}
