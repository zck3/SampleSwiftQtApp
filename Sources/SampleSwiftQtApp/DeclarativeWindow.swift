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

import Foundation
import SwiftQt

@MainActor
class DeclarativeWindow : QMainWindow {
	private var ui: UIDetails
	private var menuBar : QMenuBar?
	private var statusBar : QStatusBar?
	private var centralWidget : QWidget?

	public required init (x: SQCoord, y: SQCoord, width: SQCoord, height: SQCoord) 
	{
		self.ui = UIDetails()
		
		super.init (x: x, y: y, width: width, height: height)

		constructUI()

		self.windowResizedHandler = { [weak self] (event : QEvent) -> Bool in 
			print ("windowResizedHandler"); fflush(nil)
			self?.layoutUI ()
			return true
		}
		self.windowClosedHandler = { [weak self] in
			self?.tearDownUI()
			return true
		}
	}

	private func tearDownUI () 
	{
		setMenuBar (nil)
		setCentralWidget (nil)
	}

	private func layoutUI () 
	{
		if self.centralWidget == nil {
			makeWidgets()
			if self.centralWidget == nil {
				fatalError("Did not get declarative UI central widget.")
			}
		}
	}

	private func makeWidgets () 
	{
		guard self.centralWidget == nil else {
			return
		}

		if ui.body != nil {
			self.centralWidget = ui.body!.makeWidget(self) 
			if let central = self.centralWidget {
				let window = central.parentWidget() ?? nil
				let desc1 = String(describing: central)
				let desc2 = String(describing: window)
				print ("Declarative UI root widget is \(desc1) with parent \(desc2)")
				setCentralWidget(central)
			}
		}

		statusBar = QStatusBar ("This is the status bar.", self)
		setStatusBar (statusBar!)

		setTitle ("Declarative UI Test")
	
		show()
	}

	public func createMenus ()
	{
		let fileMenu : QMenu = QMenu("&File")
		_ = fileMenu.addAction ("&Open", {
			print ("FILE->OPEN")
		})

		let action1 = fileMenu.addAction ("C&lose", { [weak self] in
			guard let self = self else {
				return
			}
			print ("FILE->CLOSE")
			self.close()
		})
		action1!.setShortcut (QKeySequence.Close())

		let action2 = fileMenu.addAction ("E&xit", {
			print ("FILE->EXIT")
			QApplication.quit()
		})
		action2!.setShortcut (QKeySequence.Quit())

		let editMenu : QMenu = QMenu("&Edit")
		_ = editMenu.addAction ("Copy", {
			print ("EDIT->COPY")
		})
		_ = editMenu.addAction ("Cut", {
			print ("EDIT->CUT")
		})
		_ = editMenu.addAction ("Paste", {
			print ("EDIT->PASTE")
		})

		let viewMenu : QMenu = QMenu("&View")
		_ = viewMenu.addAction ("Toggle status bar", { [weak self] in
			guard let self = self else {
				return
			}
			print ("VIEW->STATUSBAR")
			if let bar = self.statusBar {
				bar.setHidden(!bar.isHidden())
			}
		})

		let helpMenu : QMenu = QMenu("&Help")
		_ = helpMenu.addAction ("&About", {
			print ("HELP->ABOUT")
			SwiftQt.infoPopup ("This is DeclarativeWindow.")
		})

		menuBar = QMenuBar ()
		menuBar!.addMenu (fileMenu)
		menuBar!.addMenu (editMenu)
		menuBar!.addMenu (viewMenu)
		menuBar!.addMenu (helpMenu)
		setMenuBar (menuBar!)
	}

	private func constructUI () 
	{
		// TODO: Add declarative menus.
		createMenus()

		// TODO: Add declarative statusBar.
                statusBar = QStatusBar ("This is the status bar.", self)
                setStatusBar (statusBar!)

		// Declarative GUI.
		let state : [String: Any] = [
			 "myVariable": "I declare it."
		]
		ui.window = self
		ui.state = state
		ui.body = 
			VStack {
				Text("This is a QTextEdit")
					.text("New text")
					.style("background-color: blue; color: yellow; selection-color: orange;")
				let text : String = state["myVariable"] as? String ?? ""
				Text(text)
					.foregroundColor(0xff0080)
					.bold()
				Form("QLineEdit")
					.italic()
				Label("This is a label")
					.font(Font("Courier", size: 22))
				HStack {
					Button("button 1") {
						SwiftQt.infoPopup ("Button 1.")
					} .bold()
					Button("button 2") {
						SwiftQt.warningPopup ("Button 2.")
					}
					.italic()
				}
				VStack {
					Button("Button 3") {
						SwiftQt.errorPopup ("Button 3.")
					}
					Button("Click Me") {
						SwiftQt.infoPopup ("This is DeclarativeWindow.")
					}
				}
				HStack {
					Button("Maybe")
					Button("Peut-etre")
				}
				.background (0xe0ffff)
				HStack {
					Form("Input form")
					Button("Enter")
				}
			}
			.spacing (3)
			.background (Color.lightCyan)
	}
}
