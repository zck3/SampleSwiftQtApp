/*=========================================================================
 * This file is a part of a demo for SwiftQt, called SampleSwiftQtApp.
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
class ManualLayoutWindow : QMainWindow {
	
	private var menuBar : QMenuBar?
	private var statusBar : QStatusBar?
	private var label1 : QLabel?
	private var button1 : QPushButton?
	private var button2 : QPushButton?
	private var button3 : QPushButton?
	private var editor : QTextEdit?
	private var textField : QLineEdit?
	private var table : QTableWidget?
	private var imageView : QLabel?
	private var webEngineView : QWebEngineView? 
	private var nWindows = -1

	public required init (x: SQCoord, y: SQCoord, width: SQCoord, height: SQCoord) 
	{
		super.init (x: x, y: y, width: width, height: height)
		constructUI()

		self.windowClosedHandler = { [weak self] in
			print ("windowClosedHandler"); fflush(nil);
			self?.tearDownUI()
		}
	}

	private func tearDownUI () 
	{
		print ("tearDownUI"); fflush(nil);
		setMenuBar (nil)
		webEngineView?.setHTML ("")
	}

	/* Manually lays out the user interface.
	 */
	private func layoutUI () {
		guard let menuBar = self.menuBar else {
			return
		}

		let menuBarHeight : Int = menuBar.height()

		guard let label1 = label1, 
			let button1 = button1, 
			let button2 = button2, 
			let button3 = button3, 
			let textField = textField, 
			let editor = editor, 
			let webEngineView = webEngineView,
			let table = table,
			let statusBar = statusBar,
			let imageView = imageView
		else {
			return
		}

		let statusBarHeight : Int = statusBar.height() 

		let availableWidth : Int = windowWidth ()
		let availableHeight : Int = windowHeight ()
		print ("Swift: LAYING OUT UI, WINDOW IS \(availableWidth)x\(availableHeight)")

		let spacing : Int = 8

		let ytop : Int = spacing + menuBarHeight
		var y : Int = ytop
		let totalHeight : Int = availableHeight 

		var x = spacing
		label1.setFrame (QRect.new(x, y, 200, 50))
		y += 50 + spacing
		button1.setFrame (QRect.new(x, y, 200, 50))
		y += 50 + spacing
		button2.setFrame (QRect.new(x, y, 200, 50))
		y += 50 + spacing
		button3.setFrame (QRect.new(x, y, 200, 50))
		y += 50 + spacing
		textField.setFrame (QRect.new(x, y, 200, 50))
		y += 50 + spacing

		let editorHeight = totalHeight - y - spacing - statusBarHeight
		editor.setFrame (QRect.new(x, y, 200, editorHeight))

		let verticalViewWidth = (availableWidth - 240 - spacing)/3

		let webviewHeight = totalHeight - spacing - ytop

		x = 240
		webEngineView.setFrame (QRect.new(x, ytop, verticalViewWidth, webviewHeight))
		x += verticalViewWidth

		table.setFrame (QRect.new(x, ytop, verticalViewWidth, webviewHeight))
		x += verticalViewWidth

		imageView.setFrame (QRect.new(x, ytop, verticalViewWidth, webviewHeight))
	}

	public func createMenus ()
	{
		// Set up menu
		let fileMenu : QMenu = QMenu("&File")
		let action0 = fileMenu.addAction ("&Open")
		action0!.triggeredHandler = {
			print ("FILE->OPEN")
		}
		let action1 = fileMenu.addAction ("C&lose")
		action1!.setShortcut (QKeySequence.Close())
		action1!.triggeredHandler = { [weak self] in
			guard let self = self else {
				return
			}
			print ("FILE->CLOSE")
			self.close()
		}
		let action2 = fileMenu.addAction ("Exit")
		action2!.setShortcut (QKeySequence.Quit())
		action2!.triggeredHandler = {
			print ("FILE->EXIT")
			QApplication.quit()
		}

		let editMenu : QMenu = QMenu("&Edit")
		let action3 = editMenu.addAction ("Copy")
		action3!.triggeredHandler = {
			print ("EDIT->COPY")
		}
		let action4 = editMenu.addAction ("Cut")
		action4!.triggeredHandler = {
			print ("EDIT->CUT")
		}
		let action5 = editMenu.addAction ("Paste")
		action5!.triggeredHandler = {
			print ("EDIT->PASTE")
		}

		let viewMenu : QMenu = QMenu("&View")
		let action6 = viewMenu.addAction ("Toggle status bar")
		action6!.triggeredHandler = { [weak self] in
			guard let self = self else {
				return
			}
			print ("VIEW->STATUSBAR")
			if let bar = self.statusBar {
				bar.setHidden(!bar.isHidden())
			}
		}

		let helpMenu : QMenu = QMenu("&Help")
		let action7 = helpMenu.addAction ("&About")
		action7!.triggeredHandler = {
			print ("HELP->ABOUT")
			SwiftQt.infoPopup ("This is ManualLayoutWindow.")
		}

		menuBar = QMenuBar ()
		menuBar!.addMenu (fileMenu)
		menuBar!.addMenu (editMenu)
		menuBar!.addMenu (viewMenu)
		menuBar!.addMenu (helpMenu)
		setMenuBar (menuBar!)
	}

	private func constructUI () 
	{
		createMenus()
	
		table = QTableWidget(self)
		table!.setColumnCount (4)
		table!.setRowCount (80)
		table!.setHorizontalHeaderLabels (["A", "B", "C", "D", "E"])
		table!.setVerticalHeaderLabels (["fee", "fie", "foe", "fum"])
		weak let weakTable : QTableWidget? = table
		table!.cellChangedHandler = { row, column in
			print ("QTableWidget cellChanged at \(row),\(column)")

			let item : QTableWidgetItem? = weakTable?.currentItem()
			if let item = item {
				let text = item.text() ?? ""
				print ("Text was changed to: \(text)")
			} else {
				print ("Didn't get item")
			}
		}
		table!.cellClickedHandler = { row, column in
			let widget = weakTable?.cellWidget(row, column)
			if widget != nil {
				print ("Got widget!")
			} else {
				print ("Didn't get widget")
			}
		}

		label1 = QLabel (self, "QLabel")
		label1!.setStyleSheet ("background-color : cyan; color : #008;");
		label1!.setWordWrap (true)
		label1!.setAlignment (Qt.AlignCenter + Qt.AlignVCenter)

		button1 = QPushButton (self, "Regular QPushButton")
		button1!.clickedHandler = { [weak self] in
			guard let self = self else {
				return
			}
			let string = self.button1?.text() ?? ""
			print ("Button \"\(string)\" clicked.")
			self.setWindowTitle ("This is a test")
			SwiftQt.infoPopup ("Hello World")
		}
		button1!.setStyleSheet ("background-color : white; color : #080;");

		button2 = QPushButton (self, "Flat QPushButton")
		button2!.setFlat (true)
		button2!.clickedHandler = { [weak self] in
			guard let self = self else {
				return
			}
			let string = self.button2?.text() ?? ""
			print ("Button \"\(string)\" clicked.")
			
			if SwiftQt.yesNoQuestion ("This is a question popup", "Do you agree?") {
				self.setTitle("You pressed YES")
			} else {
				self.setTitle("You pressed NO")
			}
		}

		button3 = QPushButton (self, "Default QPushButton")
		button3!.setDefault (true)
		button3!.clickedHandler = { [weak self] in
			guard let self = self else {
				return
			}
			let string = self.button3!.text()
			print ("Button \"\(string)\" clicked.")
			self.label1?.clear()
			QApplication.beep()
		}

		editor = QTextEdit (self)
		editor?.setText ("""
QTextEdit\nSed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo.
""")

		textField = QLineEdit (self)
		textField?.setText ("QLineEdit text field")

		webEngineView = QWebEngineView (self)
		webEngineView!.setHTML ("""

<html><h1>This is a QWebEngineView.</h1> This is a QWebEngineView.  <p><i>This is a QWebEngineView.</i> <p><b>This is a QWebEngineView.</b><img src=https://apod.nasa.gov/apod/image/2310/WitchHead_Alharbi_3051.jpg >
""")
		imageView = QLabel(self, "")

		let image = QImage("PIA25970.tif")
		print ("QImage loaded, size is \(image.width())x\(image.height())")

		//let pixmap = QPixmap("PIA25970.tif")
		//print ("QPixmap loaded, size is \(pixmap.width())x\(pixmap.height())")

		imageView!.setImage(image)

		setTitle("Sample App using SwiftQt \(SwiftQt.release)")

		self.windowResizedHandler = { [weak self] in
			guard let self = self else {
				return
			}
			let newWidth = self.width()
			let newHeight = self.height()
			print ("ManualLayoutWindow windowResizedHandler called, new size is \(newWidth)x\(newHeight).");
		}

		statusBar = QStatusBar (self, "This is the status bar.")
		setStatusBar (statusBar!)
	
		show()
	}

	public override func processEvent (_ event: SQEvent) -> Int
	{
		// This just handles windows events at the meta level.

		let eventType = event.type

		if eventType == QEventShow {
			let className = String(describing: type(of:self))
			print ("\(className) received Show event.");
			layoutUI ();
			return 0
		}

		let totalWindows = QApplication.totalMainWindows ()
		if totalWindows != nWindows {
			nWindows = totalWindows
			print ("The app currently has \(totalWindows) windows.")
		}

		return super.processEvent(event);
	}
}
