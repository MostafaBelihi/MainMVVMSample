//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2020 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

extension Date {
	/// Gets Date Components.
	func getComponents() -> DateComponents {
		let calendar = Calendar.current;
		return calendar.dateComponents([.day, .month, .year, .hour, .minute, .second, .timeZone, .weekday], from: self);
	}
	
	/// Gets Date from DateComponents.
	static func get(from components: DateComponents) -> Date? {
		let calendar = Calendar.current;
		return calendar.date(from: components);
	}
	
	/// Changes date value.
	func alter(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
		var dateComponent = DateComponents();
		
		dateComponent.second = seconds;
		dateComponent.minute = minutes;
		dateComponent.hour = hours;
		dateComponent.day = days;
		dateComponent.month = months;
		dateComponent.year = years;
		
		return Calendar.current.date(byAdding: dateComponent, to: self)!;
	}
	
	/// Gets string from date value using given format.
	/// Set the `timeZone` you want the date to be shown with.
	func toString(format: String, locale: Locale? = Locale(identifier: "en_US"), timeZone: TimeZone? = TimeZone.current) -> String {
		// Date Formatter
		let dateFormatter = DateFormatter();
		dateFormatter.locale = locale;
		dateFormatter.dateFormat = format;
		dateFormatter.timeZone = timeZone;
		
		// Convert Date to String
		return dateFormatter.string(from: self);
	}
	
	/// Gets date from string using given format.
	/// Set the supposed `timeZone` of the parsed date string.
	static func fromString(_ string: String, format: String, timeZone: TimeZone? = TimeZone.current) -> Date? {
		// Date Formatter
		let dateFormatter = DateFormatter();
		dateFormatter.dateFormat = format;
		dateFormatter.timeZone = timeZone;
		
		// Convert String to Date
		return dateFormatter.date(from: string);
	}
}
