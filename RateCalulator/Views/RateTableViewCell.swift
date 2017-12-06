//
//  RateTableViewCell.swift
//  RateCalulator
//
//  Created by Emil Marashliev on 4.12.17.
//  Copyright © 2017 ReceiptBank. All rights reserved.
//

import UIKit
import RxSwift

final class RateTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var rate: UITextField!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
