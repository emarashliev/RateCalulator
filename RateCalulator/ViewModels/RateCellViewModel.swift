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
    let amount: Variable<String?>
    
    var base: NSDecimalNumber {
        didSet {
            amount.value = base.multiplying(by: multiplier).roundedValue
        }
    }

    var multiplier = NSDecimalNumber(string: "1") {
        didSet {
            amount.value = base.multiplying(by: multiplier).roundedValue
        }
    }
    
    var code: String {
        return model.code
    }
    
    private let disposeBag = DisposeBag()
    
    init(with model: Currency) {
        self.model = model
        let amount = model.rate.multiplying(by: self.multiplier)
        self.amount = Variable<String?>(amount.roundedValue)
        self.base = model.rate
    }
    
}

//MARK: - NSDecimalNumber extension
extension NSDecimalNumber {
    
    private static let decimalHandler = NSDecimalNumberHandler(roundingMode: .plain,
                                                       scale: 3,
                                                       raiseOnExactness: true,
                                                       raiseOnOverflow: true,
                                                       raiseOnUnderflow: true,
                                                       raiseOnDivideByZero: true)
    var roundedValue: String {
        get {
            return self.rounding(accordingToBehavior: NSDecimalNumber.decimalHandler).stringValue
        }
    }
}
