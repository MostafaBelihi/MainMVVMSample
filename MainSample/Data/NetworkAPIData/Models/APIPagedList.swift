//
//  APIPagedList.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 28/03/2023.
//

import Foundation

struct APIPagedList<T: Codable>: Codable {
	var itemsCount: Int
	var items: [T]
}
