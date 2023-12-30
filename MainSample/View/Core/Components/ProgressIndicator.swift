//
//  ProgressIndicator.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 06/05/2023.
//

import SwiftUI

struct ProgressIndicator: View {
	let unifiedSize: CGFloat = !DeviceTrait.isPad ? 100 : 150
	
    var body: some View {
		withAnimation {
			VStack {
				ProgressView()
					.scaleEffect(!DeviceTrait.isPad ? 1.5 : 2.5)
					.frame(width: unifiedSize, height: unifiedSize)
					.foregroundColor(.gray)
			}
			.frame(width: unifiedSize, height: unifiedSize, alignment: .center)
			.background(.ultraThinMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 10))
		}
    }
}

struct ProgressIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ProgressIndicator()
    }
}
