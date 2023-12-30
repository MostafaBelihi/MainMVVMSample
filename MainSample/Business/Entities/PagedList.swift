//
//  PagedList.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 28/03/2023.
//

import Foundation

struct PagedList<T> {
	var list: [T]
	var totalCount: Int
	var totalPages: Int
}
