//
//  Currency.swift
//  RateCalulator
//
//  Created by Emil Marashliev on 5.12.17.
//  Copyright © 2017 ReceiptBank. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

struct Currency {
    var code: String
    var rate: NSDecimalNumber
}

extension Currency {
    private static let webService = WebService()
    
    static func all(with base: String) -> Observable<[Currency]> {
        return webService.load(base: base)
            .map { data in
                let json = JSON(data)
                let rates = json.dictionaryValue["rates"]?.dictionaryValue
                let currencies = rates?.flatMap { key, value in
                    return Currency(code: key, rate: NSDecimalNumber(string: value.stringValue))
                }
                return currencies ?? [Currency]()
            }
        }
}
