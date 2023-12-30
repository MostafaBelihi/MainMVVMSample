//
//  LottieView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 02/03/2023.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
	let lottieFile: String
	let animationView: LottieAnimationView
	var animationCompletion: ((Bool) -> Void)?
	
	init(lottieFile: String, animationCompletion: ((Bool) -> Void)? = nil) {
		self.lottieFile = lottieFile
		self.animationView = LottieAnimationView(name: lottieFile)
		self.animationCompletion = animationCompletion
	}

	func makeUIView(context: Context) -> some UIView {
		let view = UIView(frame: .zero)

		animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		animationView.play(completion: animationCompletion);

		view.addSubview(animationView)

		animationView.translatesAutoresizingMaskIntoConstraints = false
		animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
		animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		animationView.transform = CGAffineTransform(scaleX: 2, y: 2)

		return view
	}

	func updateUIView(_ uiView: UIViewType, context: Context) {

	}
}
