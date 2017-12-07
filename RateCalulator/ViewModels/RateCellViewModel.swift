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
    let amount: Variable<String?>
    
    var base: Double {
        didSet {
            let value = base * multiplier
            amount.value =  String(format: "%.3f", value)
        }
    }

    var multiplier: Double = 1 {
        didSet {
            let value = base * multiplier
            amount.value = String(format: "%.3f", value)
        }
    }
    
    var code: String {
        return model.code
    }
    
    private let disposeBag = DisposeBag()
    
    init(with model: Currency) {
        self.model = model
        let amount = model.rate * self.multiplier
        self.amount = Variable<String?>(String(format: "%.3f", amount))
        self.base = model.rate
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
