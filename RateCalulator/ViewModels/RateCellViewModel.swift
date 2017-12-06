//
//  RateCellViewModel.swift
//  RateCalulator
//
//  Created by Emil Marashliev on 6.12.17.
//  Copyright © 2017 ReceiptBank. All rights reserved.
//

import Foundation
import RxSwift

final class RateCellViewModel {
    
    let model: Currency
    var base: Decimal
    var multiplier: Decimal = 1 {
        didSet {
            value.value = base * multiplier
        }
    }
    var value = Variable<Decimal>(1)
    
    
    init(with model: Currency) {
        self.model = model
        self.base = model.rate
    }
    
}
