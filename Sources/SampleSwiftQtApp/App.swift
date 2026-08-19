/*=========================================================================
 * This file is a part of a demo of SwiftQt, called SampleSwiftQtApp.
 * (C) 2023, 2026 Zack T Smith.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 * The author may be reached at 3 at zs3 dot me.
 *=======================================================================*/

// SwiftQt
// App.swift
// 

import Foundation
import SwiftQt

@main
@MainActor
struct AppStruct {
	static func main() -> Void 
	{
		print ("SwiftQt release \(SwiftQt.release), i.e. \(SwiftQt.major).\(SwiftQt.minor) ")

		let argc = CommandLine.arguments.count
		let argv = CommandLine.arguments
		print ("argc \(argc) argv \(argv)")
		application = QApplication(argc: argc, argv: argv);

		print ("Are we on the main thread? \(Thread.isMainThread)")

		let app = App()
		QApplication.exec()
		app.teardown()
	}
}

@MainActor
class App {
	var window1 : ManualLayoutWindow?
	var window2 : GridLayoutWindow?
	var window3 : BoxLayoutWindow?

	required init () {
		let dpi = QScreen.primaryScreenLogicalDotsPerInch()
		let width = QScreen.primaryScreenWidth()
		let height = QScreen.primaryScreenHeight()
		print ("Primary screen DPI=\(dpi), size=\(width)x\(height)")

		window1 = ManualLayoutWindow(x: 100, y: 100, width: width-200, height: height-200)
		window1?.show()

		window2 = GridLayoutWindow(x: 150, y: 150, width: 500, height: 500)
		window2?.show()

		window3 = BoxLayoutWindow(x: 200, y: 200, width: 600, height: 400)
		window3?.show()
	}

	public func teardown() {
		self.window1 = nil
		self.window2 = nil
		self.window3 = nil
	}

	deinit {
	}
}
