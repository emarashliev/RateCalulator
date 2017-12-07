//
//  RateCellViewModel.swift
//  RateCalulator
//
//  Created by Emil Marashliev on 6.12.17.
//  Copyright © 2017 ReceiptBank. All rights reserved.
//

import Foundation
import RxSwift
import Differentiator

final class RateCellViewModel {
    
    let model: Currency
    var value = Variable<String?>("1")
    var base: Double {
        didSet {
            let val = base * multiplier
            value.value =  String(format: "%.3f", val)
        }
    }

    var multiplier: Double = 1 {
        didSet {
            let val = base * multiplier
            value.value =  String(format: "%.3f", val)
        }
    }
    
    var code: String {
        return model.code
    }
    
    init(with model: Currency) {
        self.model = model
        self.base = model.rate
        let val = self.base * self.multiplier
        self.value.value =  String(format: "%.3f", val)
    }
    
}


extension RateCellViewModel: Equatable, IdentifiableType {
    static func ==(lhs: RateCellViewModel, rhs: RateCellViewModel) -> Bool {
        return lhs.code == rhs.code
    }
    
    var identity : String {
        return code
    }
}
