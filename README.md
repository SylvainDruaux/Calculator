#  iOS Calculator 
A stylish, responsive and MVC iOS calculator app with fundamental arithmetic operations.

MVC Pattern:
- Model (Calculator/Model/Calculator.swift) contains arithmetic operations and logic.
- History (Calculator/Model/Calculator.swift) keep an history of past operations. Also part of the Model.
- Controller (Calculator/Controller/ViewController.swift) calls methods of calculator model in IBActions and updates IBOutlets.
- View (Calculator/Controller/Main.Storyboard) is created with Storyboard.

Responsive Layout:
- Used stack views.
- Created constraint variations based on the screen orientation.

Adaptive output based on screen orientation and number length:
- Automatic font adjustment when max character is reached and minus sign added.
- Use scientific notation when the maximum number of characters allowed is exceeded.
- Change display of the UITextView in landscape mode only (left alignement).

Cool Features:
- The operand buttons act the same as on the official Apple calculator.
- You can remove a number from the figure being added via a swipe to the right or to the left on the UILabel, as on the official Apple calculator.
- Automatically scroll to last line when UITextView is full.
- Double click on AC button, will also clear the history.


Next steps:
- Responsiveness on small screen iPhones (under iPhone 11).
- Add a new cool feature: swiping right or left on UITextView will display expressions with their results.
- Improve the code.

Future steps (if enough time):
- Add some advanced arithmetic operations in landscape mode.
