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

final class RateTableViewModel {
    
    
    let selectedCurrency = Variable("EUR")
    let selectedCellModelView = Variable<RateCellViewModel?>(nil)
    let cellViewModels = Variable([RateCellViewModel]())
    private let disposeBag = DisposeBag()
    
    func fetching() {
        Observable<Int>
            .interval(1, scheduler: ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.background))
            .flatMap { [unowned self] _ in
                return Currency.all(with: self.selectedCurrency.value)
            }
            .subscribe { [unowned self] event in
                switch event {
                case .next(let element):
                    _ = element.map({ currency in
                        let modelView = self.cellViewModels.value.filter { cellViewModel in
                            cellViewModel.code == currency.code
                            }.first
                        modelView?.base = currency.rate
                        modelView?.multiplier = Double( self.selectedCellModelView.value?.value.value ?? "1")!
                    })
                case .error(let error):
                    print(error.localizedDescription)
                case .completed:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    func initialFetch() {
        Currency.all(with: self.selectedCurrency.value)
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.background))
            .subscribe { [unowned self] event in
                switch event {
                case .next(let element):
                    self.cellViewModels.value = element.map { currency in
                        RateCellViewModel(with: currency)
                    }
                    
                    let selectedCellViewModel =
                        RateCellViewModel(with: Currency(code: self.selectedCurrency.value, rate: 1))
                    self.cellViewModels.value.insert(selectedCellViewModel, at: 0)
                case .error(let error):
                    print(error.localizedDescription)
                case .completed:
                    break
                }
                
            }
            .disposed(by: disposeBag)
        
        selectedCurrency.asObservable()
            .subscribe(onNext: { [unowned self] code in
                self.selectedCellModelView.value = self.cellViewModels.value.filter { cellViewModel in
                    cellViewModel.code == code
                    }.first
            })
            .disposed(by: disposeBag)
    }
    
    
}
