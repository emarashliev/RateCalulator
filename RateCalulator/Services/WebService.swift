//
//  WebService.swift
//  RateCalulator
//
//  Created by Emil Marashliev on 5.12.17.
//  Copyright © 2017 ReceiptBank. All rights reserved.
//

import Foundation
import RxSwift

final class WebService {
    
    private let baseUrl = "https://revolut.duckdns.org/latest"

    func load(base: String) -> Observable<Data> {
        let url = URL(string: "\(baseUrl)?base=\(base)")!
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
    }
}
