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
class GridLayoutWindow : QMainWindow {
	
	private var menuBar : QMenuBar?
	private var statusBar : QStatusBar?
	private var centralWidget : QWidget?
	private var mainLayout : QGridLayout?

	private var label1 : QLabel?
	private var label3 : QLabel?
	private var label4 : QLabel?
	private var imageView : QLabel?
	private var scrollArea : QScrollArea?
	private var label6 : QLabel?
	private var groupBox : QGroupBox?
	private var radioButton1 : QRadioButton?
	private var radioButton2 : QRadioButton?
	private var checkbox : QCheckBox?
	private var lcdNumber : QLCDNumber?
	private var groupLayout : QHBoxLayout?
	private var slider : QSlider?

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
		let action0 = fileMenu.addAction ("&Open", {
			print ("FILE->OPEN")
		})
		action0!.setShortcut (QKeySequence.Open())

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
		let action3 = QAction("Copy")
		_ = editMenu.addAction (action3, {
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
			SwiftQt.infoPopup ("This is GridLayoutWindow.")
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
	
		centralWidget = QWidget(self)
		mainLayout = QGridLayout(centralWidget!)

		label1 = QLabel (self, "This is a QLabel")
		label1!.setStyleSheet ("background-color : cyan; color : #008;");
		label1!.setWordWrap (true)
		label1!.setAlignment (Qt.AlignCenter + Qt.AlignVCenter)

		label3 = QLabel (self, "This is a QLabel")
		label3!.setStyleSheet ("background-color : purple; color : yellow;");
		label3!.setWordWrap (true)
		label3!.setAlignment (Qt.AlignCenter + Qt.AlignVCenter)

		label4 = QLabel (self, "This is a QLabel")
		label4!.setStyleSheet ("background-color : orange; color : red;");
		label4!.setWordWrap (false)
		label4!.setAlignment (Qt.AlignCenter + Qt.AlignVCenter)

		label6 = QLabel (self, "This is a QLabel")
		label6!.setStyleSheet ("background-color : yellow; color : red;");
		label6!.setWordWrap (false)
		label6!.setAlignment (Qt.AlignCenter + Qt.AlignVCenter)

		slider = QSlider (self)
		if let slider=slider {
			slider.setOrientation (Qt.Horizontal)
			slider.setStyleSheet ("background-color : green; color : white;")
			slider.setValue (20)
                        weak let weakSelf = self
			slider.valueChangedSlot = { value in 
				guard let slider = weakSelf?.slider,
				      let lcd = weakSelf?.lcdNumber else {
					return 
				}
				let value : Int = slider.value()
				print ("Slider value changed to \(value)")
				lcd.display(value)
			}
		}

		// Radio buttons are contained in a group box
		groupBox = QGroupBox (self)
		groupBox?.setStyleSheet ("""
			QGroupBox { 
				border: 1px solid #ccc;
				border-radius: 8px; 
				margin-top: 12px;
				font: italic;
				padding: 2px;
				//height: 260px;
			}
			QGroupBox::title { 
				height: 30px;
				top: -10px;
				padding: 0px 5px 0px 5px;
				border: 1px solid #ccc;
				border-radius: 5px;
				color: yellow;
				background-color: black;
				subcontrol-position: top center;
				/*padding: 13px;*/
			} 
		""")
		groupBox?.setAlignment(Qt.AlignCenter)
		//groupBox?.setMinimumSize(QSize(1, 120))
		groupLayout = QHBoxLayout(groupBox!)

		radioButton1 = QRadioButton (self, "Radio Button 1")
		radioButton1!.toggledSlot = { [weak self] in
			guard let self = self else {
				return 
			}
			let value = self.radioButton1?.isChecked() ?? false
			print ("radioButton1 was toggled, isChecked=\(value)")
		}
		radioButton2 = QRadioButton (self,"Radio Button 2")
		radioButton2!.toggledSlot = { [weak self] in
			guard let self = self else {
				return 
			}
			let value = self.radioButton2?.isChecked() ?? false
			print ("radioButton2 was toggled, isChecked=\(value)")
		}
		groupLayout!.addWidget(radioButton1!)
		groupLayout!.addWidget(radioButton2!)

		checkbox = QCheckBox (self, "QCheckBox")
		checkbox!.stateChangedSlot = { [weak self] in
			guard let self = self else {
				return 
			}
			let checkState = self.checkbox?.checkState() // 3 possible values
			var string = "?"
			switch (checkState) {
			case Qt.Checked: 
				string = "checked"
			case Qt.PartiallyChecked: 
				string = "partiallychecked"
			default: 
				string = "unchecked"
			}
			print ("The checkbox was toggled, checkstate=\(string)")
		}
		
		lcdNumber = QLCDNumber(self, numberOfDigits: 7)
		if let lcdNumber=lcdNumber {
			lcdNumber.setSmallDecimalPoint(true)
			lcdNumber.display(3.14159)
			lcdNumber.setStyleSheet ("background-color : black; color : green;")
			lcdNumber.setMaximumHeight (19)
		}

		scrollArea = QScrollArea(self)
		imageView = QLabel(scrollArea!, "")
		scrollArea?.setWidget(imageView!)

		let image = QImage("PIA25970.tif")
		print ("image loaded, size is \(image.width())x\(image.height())")
		imageView!.setImage(image)
		let imageWidth = image.width()
		let imageHeight = image.height()
		imageView?.setFrame (QRect.new(0, 0, imageWidth, imageHeight))

		mainLayout?.addWidget(label1!, row: 0, column: 0)
		mainLayout?.addWidget(slider!, row: 0, column: 1)
		mainLayout?.addWidget(label3!, row: 0, column: 2)

		mainLayout?.addWidget(label4!, row: 1, column: 0)
		mainLayout?.addWidget(scrollArea!, row: 1, column: 1)
		mainLayout?.addWidget(label6!, row: 1, column: 2)

		mainLayout?.addWidget(checkbox!, row: 2, column: 0)
		mainLayout?.addWidget(groupBox!, row: 2, column: 1)
		mainLayout?.addWidget(lcdNumber!, row: 2, column: 2)

		self.windowResizedHandler = { [weak self] (_ event: QEvent) -> Bool in
			guard let self = self else {
				return false
			}
			let newWidth = self.width()
			let newHeight = self.height()
			print ("GridLayoutWindow windowResizedHandler called, new size is \(newWidth)x\(newHeight).");
			return true
		}

		setTitle ("Grid Layout")

		setCentralWidget(centralWidget!)

		statusBar = QStatusBar (self, "This is the status bar.")
		setStatusBar (statusBar!)
	
		show()
	}

	public override func event (_ event: QEvent) -> Bool
	{
		// This just handles windows events at the meta level.

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
