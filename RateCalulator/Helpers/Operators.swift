//
//  Operators.swift
//  RateCalulator
//
//  Created by Emil Marashliev on 7.12.17.
//  Copyright © 2017 ReceiptBank. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Two way binding operator between control property and variable
infix operator <-> : DefaultPrecedence

func <-> <T>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable{
    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    
    let bindToVariable = property
        .subscribe(onNext: { n in
            variable.value = n
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}
