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
    var items: [RateCellViewModel]
}

extension Section : AnimatableSectionModelType {
    var identity: String {
        return items.first?.code ?? ""
    }
    
    init(original: Section, items: [RateCellViewModel]) {
        self = original
        self.items = items
    }
}

final class RateTableViewModel {
    
    let sections = Variable([Section]())
    var selectedCurrency = "EUR"
    var cellViewModels = [RateCellViewModel]()
    private let disposeBag = DisposeBag()
    
    func fetching() {
        Observable<Int>
            .interval(1, scheduler: ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.background))
            .flatMap { [unowned self] _ in
                return Currency.all(with: self.selectedCurrency)
            }
            .subscribe { [unowned self] event in
                switch event {
                case .next(let element):
                    _ = element.map({ currency in
                        let modelView = self.cellViewModels.filter { cellViewModel in
                            cellViewModel.code == currency.code
                        }.first
                        modelView?.base = currency.rate
                    })
                case .error(let error):
                    print(error.localizedDescription)
                case .completed:
                    break
                }
        }.disposed(by: disposeBag)
    }
    
    
    func initialFetch() {
        Currency.all(with: self.selectedCurrency)
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.background))
            .subscribe { [unowned self] event in
                switch event {
                case .next(let element):
                    self.cellViewModels = element.map { currency in
                        RateCellViewModel(with: currency)
                    }
                    
                    let selectedCellViewModel = RateCellViewModel(with: Currency(code: self.selectedCurrency, rate: 1))
                    self.sections.value = [Section(header: "", items: [selectedCellViewModel]),
                                           Section(header: "", items: self.cellViewModels)]
                case .error(let error):
                    print(error.localizedDescription)
                case .completed:
                    break
                }
                
            }.disposed(by: disposeBag)
    }
    
    
}
