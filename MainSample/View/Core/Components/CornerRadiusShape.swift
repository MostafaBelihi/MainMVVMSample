//
//  CornerRadiusShape.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 04/04/2023.
//

// Credit: https://stackoverflow.com/a/60512484/7128177

import SwiftUI

struct CornerRadiusShape: Shape {
	var radius = CGFloat.infinity
	var corners = UIRectCorner.allCorners
	
	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
	}
}
