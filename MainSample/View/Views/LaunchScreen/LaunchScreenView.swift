//
//  LaunchScreenView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 02/03/2023.
//

import SwiftUI

struct LaunchScreenView: View {
	var animationCompletion: ((Bool) -> Void)?

	var body: some View {
		GeometryReader { geo in
			ZStack {
				LottieView(lottieFile: "SplashAnimation", animationCompletion: animationCompletion)
			}
			.frame(width: geo.size.width, height: geo.size.height)
			.background(.backgroundTinted)
		}
	}
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
