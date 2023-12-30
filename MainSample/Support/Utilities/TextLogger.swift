//
//  TextLogger.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 31/07/2023.
//

import Foundation

// TODO: For temp use only. Disable otherwise until it's well analyzed and designed.
//var textLogger = TextLogger()

// [TechDebt]TODO: This is a preliminary implementation to be elaborated later
class TextLogger: TextOutputStream {
	let logFileName = "log_\(Date.now.toString(format: "yyyy-MM-dd_HH-mm-ss")).txt"
	
	func log(_ text: String) {
		write(text);
		write("\n");
	}
	
	func write(_ string: String) {
		let fm = FileManager.default
		let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(logFileName)
		if let handle = try? FileHandle(forWritingTo: log) {
			handle.seekToEndOfFile()
			handle.write(string.data(using: .utf8)!)
			handle.closeFile()
		} else {
			try? string.data(using: .utf8)?.write(to: log)
		}
	}
}
