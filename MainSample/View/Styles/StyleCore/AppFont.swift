//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2023 Mostafa AlBelliehy. All rights reserved.
//

import SwiftUI

struct AppFont {
	var size: CGFloat;
	var weight: Font.Weight;

	/// Constant collection of all app's font names per language and font weight.
	let fontNames: [FontName] = [
		FontName(language: .arabic, weight: .light, name: "LamaRounded-Light"),
		FontName(language: .arabic, weight: .regular, name: "LamaRounded-Regular"),
		FontName(language: .arabic, weight: .medium, name: "LamaRounded-Medium"),
		FontName(language: .arabic, weight: .semibold, name: "LamaRounded-SemiBold"),
		FontName(language: .arabic, weight: .bold, name: "LamaRounded-Bold"),
		FontName(language: .arabic, weight: .black, name: "LamaRounded-ExtraBold")
	];

	struct FontName {
		var language: Language;
		var weight: Font.Weight;
		var name: String;
	}

	/// Get font name per language and font wight
	var fontName: String? {
		return fontNames.first(where: { $0.language == LocaleManager.language && $0.weight == weight })?.name;
	}

	/// Get Font from font data
	var font: Font {
		guard let fontName = fontName else {
			return defaultFont;
		}

		return Font.custom(fontName, fixedSize: size);
	}

	private var defaultFont: Font {
		return Font.system(size: size, weight: weight);
	}
}
