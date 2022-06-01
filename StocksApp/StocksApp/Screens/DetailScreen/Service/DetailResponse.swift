//
//  DetailResponse.swift
//  StocksApp
//
//  Created by Dilyara on 01.06.2022.
//

import Foundation

struct Chart: Decodable {
    let prices: [[Double]]
}
