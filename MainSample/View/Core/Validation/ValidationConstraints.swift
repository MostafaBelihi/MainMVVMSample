//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

// MARK: - Lengths
struct ValidationConstraints {
	static let nameLengthMin = 2;
	static let nameLengthMax = 50;
	static let usernameLengthMin = 2;
	static let usernameLengthMax = 256;
	static let emailLengthMin = 2;
	static let emailLengthMax = 256;
	static let phoneLengthMin = 11;
	static let phoneLengthMax = 25;
	static let passwordLengthMin = 8;
	static let passwordLengthMax = 256;
	static let addressLengthMin = 2;
	static let addressLengthMax = 150;
	static let postCodeLengthMin = 5;
	static let postCodeLengthMax = 10;
}

// MARK: - Patterns
extension ValidationConstraints {
	static let stringLengthRangePattern = "^.{<<<0>>>,<<<1>>>}$";
	static let usernamePattern = "^[a-zA-Z]([\\w\\.\\-\\@]+)$";
	static let emailPattern = "^[a-zA-Z]([\\w\\.\\-]+)@([\\w\\-]+)((\\.(\\w){2,3})+)$";
	static let phoneNumberPattern = "^\\d{4,20}$";
	static let passwordPattern = "^((?=\\S*?[A-Z])(?=\\S*?[a-z])(?=\\S*?[0-9]).{7,})\\S$";
}
