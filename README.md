<img src="https://user-images.githubusercontent.com/3011832/154659440-d206a01e-a6bd-47a0-8428-5357799816de.png" alt="SwiftLayout Logo" height="180" />

*Yesterday never dies*

**A swifty way to use UIKit**

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fioskrew%2FSwiftLayout%2Fbadge%3Ftype%3Dswift-versions)](https://github.com/ioskrew/SwiftLayout)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fioskrew%2FSwiftLayout%2Fbadge%3Ftype%3Dplatforms)](https://github.com/ioskrew/SwiftLayout)

# requirements

- iOS 13+
- Swift 5.4+

# installation

**SwiftLayout** supply **SPM** only

```swift
dependencies: [
  .package(url: "https://github.com/ioskrew/SwiftLayout", from: "1.7.0"),
],
```

# simple usage

- for pure **UIKit**

```swift
class SampleCell: UITableViewCell {
    
    let firstNameLabel: UILabel = .init()
    let lastNameLabel: UILabel = .init()
    
    func initViews() {
        contentView.addSubview(firstNameLabel)
        contentView.addSubview(lastNameLabel)
        
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            firstNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lastNameLabel.leadingAnchor.constraint(equalTo: firstNameLabel.trailingAnchor),
            lastNameLabel.trailingAnchor.constraint(equalTo: firstNameLabel.trailingAnchor),
            lastNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            lastNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}

```

- in **SwiftLayout**

```swift
contentView {
  firstNameLabel.anchors {
    Anchors(.top, .leading, .bottom)
  }
  lastNameLabel.anchors {
    Anchors(.leading, .trailing).equalTo(firstNameLabel, attribute: .trailing)
    Anchors(.top, .bottom)
  }
}.finalActive()
```

*That easy* (thanx bob)

# details

### addSubview

```swift
contentView {
  firstNameLabel
}
```

equal

```swift
contentView.addSubview(firstNameLabel)
```

- contentView is superview
- firstNameLabel in parenthesis is subview

### addSubview one more

```swift
contentView {
  firstNameLabel
  lastNameLabel
  ...
}
```

- subviews in parenthesis currently max to 7 is possible

### autolayout constraint to superview

```swift
contentView {
  firstNameLabel.anchors {
    Anchors(.top)
    // or
    Anchors(.top).equalTo(contentView, attribute: .top, constant: 0.0)
  }
}
```

in UIKit

```swift
NSLayoutConstraint(item: firstNameLabel,
                   attribute: NSLayoutConstraint.Attribute.top,
                   relatedBy: .equal,
                   toItem: contentView,
                   attribute: .top,
                   multiplier: 1.0,
                   constant: 0.0)
```

### subview in subview and anchors

```swift
contentView {
  firstNameContent.anchors {
    Anchors.cap() // leading, top, trailing equal to contentView
  }.sublayout {
    firstNameLabel.anchors {
      Anchors.allSides()
    }
  }
}
```

- using **sublayout** function after **anchors**

### animations

- [animation sample](https://gist.github.com/oozoofrog/26e3864dd0a0adeb326ef5254b89768c)

[![animation in update layout](https://user-images.githubusercontent.com/3011832/156907933-86f398c4-1c0b-4778-a5c6-61314dc9d92a.png)](https://user-images.githubusercontent.com/3011832/156907929-e286adb2-8c40-4223-b9d2-9d69a462aaee.mp4)

# utility

**SwiftLayoutPrinter**

- printing UIView hierarchy and autolayout constraint relationship to SwiftLayout syntax

```swift
contentView.addSubview(firstNameLabel)
```

- You can use SwiftLayoutPrinter in source or debug console

```swift
(lldb) po SwiftLayoutPrinter(contentView)
...
contentView {
  firstNameLabel
}
...
```

*That easy*

# credits

- oozoofrog([@oozoofrog](https://twitter.com/oozoofrog))
- gmlwhdtjd([gmlwhdtjd](https://github.com/gmlwhdtjd))
