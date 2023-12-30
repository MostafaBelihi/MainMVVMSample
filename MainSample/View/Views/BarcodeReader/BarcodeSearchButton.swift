//
//  BarcodeSearchButton.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 16/08/2023.
//

import SwiftUI

struct BarcodeSearchButton: View {

	// Actions
	@Binding var code: String
	@State private var showingBarCodeSearch = false
	var onDismiss: (() -> Void)

	var body: some View {
		Button {
			code = "";
			showingBarCodeSearch = true;
		} label: {
			Image("barcode")
				.resizable()
				.scaledToFit()
				.frame(width: !DeviceTrait.isPad ? 20 : 30)
				.padding(.leading, 5)
				.foregroundColor(.tintPrimary)
		}

		.fullScreenCover(isPresented: $showingBarCodeSearch, onDismiss: onDismiss, content: {
			// SampleSimplification:: 
//			BarcodeReaderView(code: $code)
		})
    }
}

//#Preview {
//    BarcodeSearchButton()
//}
