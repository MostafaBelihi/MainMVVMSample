//
//  MessageView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 10/08/2023.
//

import SwiftUI

struct MessageView: View {
	var mainMessage: String
	var mainMessageColor: Color = .tintPrimary

	var secondaryMessage: String?
	var secondaryMessageColor: Color?
	
	var imageName: String?
	var animationFileName: String?
	
	var width: CGFloat
	
	var actionButtonText: String?
	var actionButtonHandler: VoidClosure?
	
    var body: some View {
		VStack(spacing: 40) {
			VStack(spacing: 10) {
				if let imageName = imageName {
					Image(imageName)
						.resizable()
						.scaledToFit()
						.frame(width: width * 0.6)
				}
				else if let animationFileName = animationFileName {
					LottieView(lottieFile: animationFileName)
						.frame(width: width * 0.35, height: width * 0.35)
                        .padding(.bottom, !DeviceTrait.isPad ? 40 : 90)
				}
				
				Text(mainMessage)
					.multilineTextAlignment(.center)
					.font(AppFont(size: TextStyle.medium.fontSize, weight: .bold).font)
					.foregroundColor(mainMessageColor)
				
				if let secondaryMessage = secondaryMessage {
					Text(secondaryMessage)
						.multilineTextAlignment(.center)
						.foregroundColor(secondaryMessageColor)
				}
			}
			.textBaseStyle()
			
			if let actionButtonText = actionButtonText, let actionButtonHandler = actionButtonHandler {
				TintedButton(title: actionButtonText,
							 height: ViewSpecs.mainButtonHeight,
							 cornerRadius: ViewSpecs.globalCornerRadius,
							 action: actionButtonHandler)
			}
		}
		.frame(width: width)
		.frame(maxHeight: .infinity)
    }
}

//#Preview {
//	MessageView(mainMessage: Localizables.emptyCartMessage.text,
//			  secondaryMessage: Localizables.emptyCartMessage2.text,
//			  imageName: "placeholder",
//			  width: UIScreen.main.bounds.width * 0.8,
//			  actionButtonText: "Go") {
//		print("")
//	}
//}
//
//#Preview {
//	MessageView(mainMessage: Localizables.emptyCartMessage.text,
//			  secondaryMessage: Localizables.emptyCartMessage2.text,
//			  animationFileName: "Empty.json",
//			  width: UIScreen.main.bounds.width * 0.8,
//			  actionButtonText: "Go") {
//		print("")
//	}
//}
//
//#Preview {
//	MessageView(mainMessage: Localizables.emptyCartMessage.text,
//			  secondaryMessage: Localizables.emptyCartMessage2.text,
//			  animationFileName: "Empty.json",
//			  width: UIScreen.main.bounds.width * 0.8)
//}
//
//#Preview {
//	MessageView(mainMessage: Localizables.emptyCartMessage.text,
//			  animationFileName: "Empty.json",
//			  width: UIScreen.main.bounds.width * 0.8)
//}
