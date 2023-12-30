//
//  MathTests.swift
//  NadaShopTests
//
//  Created by Mostafa AlBelliehy on 10/09/2021.
//

import XCTest
@testable import MainSample

class MathTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

	func testFormatMoneyNumber() {
		// Given
		let number = Double(1000000);
		let number2 = Double(1);

		// When
		let formattedNumber1 = Math.formatMoneyNumber(number: number,
													 withThousandSeparators: true,
													 originalNumberFactor: .none,
													 newNumberFactor: .million,
													 currency: Currency.usd,
													 shouldGetCurrencySymbol: false);
		let formattedNumber2 = Math.formatMoneyNumber(number: number,
													  withThousandSeparators: true,
													  originalNumberFactor: .none,
													  newNumberFactor: .none,
													  currency: Currency.usd,
													  shouldGetCurrencySymbol: true);
		let formattedNumber3 = Math.formatMoneyNumber(number: number2,
													  withThousandSeparators: true,
													  originalNumberFactor: .million,
													  newNumberFactor: .none,
													  currency: Currency.usd,
													  shouldGetCurrencySymbol: true);

		// Then
		XCTAssertEqual(formattedNumber1, "1M USD");
		XCTAssertEqual(formattedNumber2, "$1,000,000");
		XCTAssertEqual(formattedNumber3, "$1,000,000");
	}

	func testRound() {
		// Given
		let number1 = Double(1.111111);
		let number2 = Double(2.55555);

		// When
		let roundedNumber1 = Math.round(number: number1, decimalPoints: 2);
		let roundedNumber2 = Math.round(number: number2, decimalPoints: 2);
		let roundedNumber3 = Math.round(number: number2, decimalPoints: 1);
		let roundedNumber4 = Math.round(number: number2, decimalPoints: 0);

		// Then
		XCTAssertEqual(roundedNumber1, 1.11);
		XCTAssertEqual(roundedNumber2, 2.56);
		XCTAssertEqual(roundedNumber3, 2.6);
		XCTAssertEqual(roundedNumber4, 3);
	}

}
