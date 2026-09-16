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
class BoxLayoutWindow : QMainWindow {
	
	private var menuBar : QMenuBar?
	private var statusBar : QStatusBar?
	private var centralWidget : QWidget?
	private var horizontalLayout : QHBoxLayout?
	private var verticalLayout : QVBoxLayout?
	private var leftmostWidget : QWidget?

	private var label1 : QLabel?
	private var label2 : QLabel?
	private var label3 : QLabel?
	private var label4 : QLabel?
	private var label6 : QLabel?
	private var label7 : QLabel?
	private var label8 : QLabel?
	private var label9 : QLabel?
	private var calendar : QCalendarWidget?
	private var document : QPdfDocument?
	private var pdfview : QPdfView?

	private var nWindows = -1

	public required init (x: SQCoord, y: SQCoord, width: SQCoord, height: SQCoord) 
	{
		super.init (x: x, y: y, width: width, height: height)

		constructUI()

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
			SwiftQt.infoPopup ("This is BoxLayoutWindow.")
		})

		menuBar = QMenuBar ()
		menuBar!.addMenu (fileMenu)
		menuBar!.addMenu (editMenu)
		menuBar!.addMenu (viewMenu)
		menuBar!.addMenu (helpMenu)
		setMenuBar (menuBar!)
	}

	/*------------------------------------------------------------------
	 * Constructs the GUI and sets event handlers.
	 */
	private func constructUI () 
	{
		createMenus()
	
		statusBar = QStatusBar (self, "This is the status bar.")
		setStatusBar (statusBar!)
	
		// Create box layouts and their contents
		centralWidget = QWidget(self)
		horizontalLayout = QHBoxLayout(centralWidget!)

		leftmostWidget = QWidget(self)
		leftmostWidget!.setMinimumSize (QSize(200,1))
		leftmostWidget!.setMaximumWidth (200)
		verticalLayout = QVBoxLayout(leftmostWidget!)
		verticalLayout!.setSpacing(5)
		//verticalLayout!.setMaximumSize (QSize(200,999))
		horizontalLayout!.addWidget (leftmostWidget!)

		label1 = QLabel (self, "This is a QLabel")
		label1!.setStyleSheet ("background-color : cyan; color : #008;");
		label1!.setWordWrap (true)
		label1!.setAlignment (Qt.AlignCenter + Qt.AlignVCenter)

		label2 = QLabel (self, "This is a QLabel")
		label2!.setStyleSheet ("background-color : blue; color : white;");
		label2!.setWordWrap (true)
		label2!.setAlignment (Qt.AlignCenter + Qt.AlignVCenter)

		label3 = QLabel (self, "This is a QLabel")
		label3!.setStyleSheet ("background-color : purple; color : yellow;");
		label3!.setWordWrap (true)
		label3!.setAlignment (Qt.AlignCenter + Qt.AlignVCenter)

		label4 = QLabel (self, "This is a QLabel")
		label4!.setStyleSheet ("background-color : orange; color : red;");
		label4!.setWordWrap (false)
		label4!.setAlignment (Qt.AlignCenter + Qt.AlignVCenter)

		calendar = QCalendarWidget(self)
		calendar!.setMinimumSize (QSize(200,250))
		calendar!.setHorizontalHeaderFormat(QCalendarWidget.SingleLetterDayNames)
		calendar!.selectionChangedSlot = { [weak self] in
			guard let self = self else {
				return 
			}
			if let date : QDate = self.calendar?.selectedDate() {
				let y = date.year()
				let m = date.month()
				let d = date.day()
				print ("You selected: Year=\(y) Month=\(m) Day=\(d)")
			}
		}

		verticalLayout?.addWidget(label1!)
		verticalLayout?.addWidget(label2!)
		verticalLayout?.addWidget(label3!)
		verticalLayout?.addWidget(label4!)
		verticalLayout?.addWidget(calendar!)

		document = QPdfDocument(self)
		let loadResult = document?.load("Metamorphoseon.pdf") ?? -1
		if loadResult != Qt.PdfNone {
			print ("Error loading sample PDF \(loadResult).")
		} else {
			let count = document?.pageCount() ?? -1
			print ("Loaded PDF, total pages = \(count)")
		}

		pdfview = QPdfView(self)
		if let document = document {
			pdfview?.setDocument(document)
			pdfview?.setPageMode(Qt.PageModeMultiPage)
			pdfview?.setZoomMode(Qt.ZoomModeFitToWidth)
			print ("Set PDF document.")
		} else {
			print ("Failed to load PDF.")
		}

		horizontalLayout?.addWidget(pdfview!)

		self.windowResizedHandler = { [weak self] (_ event: QEvent) -> Bool in
			guard let self = self else {
				return false
			}
			let newWidth = self.width()
			let newHeight = self.height()
			print ("BoxLayoutWindow windowResizedHandler called, new size is \(newWidth)x\(newHeight).");
			return true
		}

		setTitle ("Box Layout")

		setCentralWidget(centralWidget!)
		show()
	}

	public override func event (_ event: QEvent) -> Bool
	{
		let eventType = event.type

		if eventType == QEventShow {
			let className = String(describing: type(of:self))
			print ("\(className) got QEventShow event.");
			return true
		}

		let totalWindows = QApplication.totalMainWindows ()
		if totalWindows != nWindows {
			nWindows = totalWindows
			print ("The app currently has \(totalWindows) windows.")
		}

		return super.event(event) 
	}
}
