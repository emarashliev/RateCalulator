//
//  RateTableViewModel.swift
//  RateCalulator
//
//  Created by Emil Marashliev on 5.12.17.
//  Copyright © 2017 ReceiptBank. All rights reserved.
//

import Foundation
import RxSwift
import Differentiator

struct Section {
    var header: String
    var items: [Currency]
}

extension Section : AnimatableSectionModelType {
    var identity: String {
        return items.first?.code ?? ""
    }
    
    init(original: Section, items: [Currency]) {
        self = original
        self.items = items
    }
}

final class RateTableViewModel {
    
    let sections = Variable([Section]())
    var selectedCurrency = "EUR"
    var timer: Disposable?
    private let disposeBag = DisposeBag()
    
    func fetching() {
        timer = Observable<Int>
            .interval(1, scheduler: ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.background))
            .flatMap { [unowned self] _ in
                return Currency.all(with: self.selectedCurrency)
            }
            .subscribe { event in
                if let currences = event.element {
                    self.sections.value = [Section(header: "", items: [Currency(code: self.selectedCurrency, rate: 1)]),
                                           Section(header: "", items:currences)]
                }
        }
    }
    
    
    func fetch() {
        Currency.all(with: self.selectedCurrency)
            .subscribe { event in
                if let currences = event.element {
                    self.sections.value = [Section(header: "", items: [Currency(code: self.selectedCurrency, rate: 1)]),
                                           Section(header: "", items:currences)]
                }
        }.dispose()
    }
    
    
}
