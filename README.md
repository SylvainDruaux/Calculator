#  iOS Calculator 

An elegant iOS MVC calculator app, inspired by the official one from Apple.

|United States|France|
|--|--|
|<img src="/Resources/iPhone-14-Pro-Portrait-USA.png" width="200">|<img src="/Resources/iPhone-14-Pro-Portrait-FRA.png" width="200">|

## Requirements

* iOS 16+

## Usage

This application works like the official Apple iOS Calculator, but only with basic arithmetic operations.
It also has a history of past expressions, which can be cleaned by double tapping on the AC button.

## Features

* Responsive Layout from the iPhone SE (3rd Generation) to the last version.
* Portrait and Landscape mode.
* Decimal separator and display based on national writing conventions.
* Adaptive output based on screen orientation and number length:
    * Limitation of the maximum number of characters allowed:
        * The font will automatically adjust when the limit is reached and a minus sign is added.
        * The number will be converted into scientific notation if it exceeds the limit.
* Buttons' behavior, similar to the official Apple app:
	* Rounded buttons and a Gray/Blue color palette.
    * Animation effects according to the type of touch event.
* Removal of a digit from the number being added by swiping right or left.
* Scrolls automatically to the last line when the history becomes too long.
* Double tapping on the AC button will also clear the history.

## Structure

This application strives to stick to the MVC architecture pattern.
* Model
    * Calculator.swift: Where arithmetic operations and logic happens.
    * History.swift: Keeps an history of past operations. Also part of the Model.
* Controller
    * ViewController.swift: Calls methods of calculator model in IBActions and updates IBOutlets.
* View
    * Main.Storyboard: Main screen.
    * CalculatorButton.swift: Custom class to manage button appearance and animation.

## Demo

|United States|France|
|--|--|
|<img src="/Resources/Demo-iPhone-14-Pro-Portrait-USA.gif" width="200">|<img src="/Resources/Demo-iPhone-14-Pro-Portrait-FRA.gif" width="200">|

### Landscape mode

|United States|France|
|--|--|
|<img src="/Resources/iPhone-14-Pro-Landscape-USA.png" width="300">|<img src="/Resources/iPhone-14-Pro-Landscape-FRA.png" width="300">|

## License

See LICENSE.md for details
