# appbooster-client-logger-ios

Framework for iOS client logging of Appbooster organization.

## Installation

CocoaPods:

```
pod 'AppboosterClientLogger'
```

## Usage

### Activation
```
AppboosterClientLogger.activate(writeLogs: true)
```

### Write line to log
```
AppboosterClientLogger.writeLineToDefaultLogFile("Log line")
```
or
```
AppboosterClientLogger.writeLine("Log line", toFile: "<filename>")
```

### Read log
```
AppboosterClientLogger.readDefaultLogFile(completion: { log in })
```
or
```
AppboosterClientLogger.readLogFromFile("<filename>", completion: { log in })
```

### Get log as data
```
AppboosterClientLogger.defaultLogFileData(completion: { data in })
```
or
```
AppboosterClientLogger.logDataFromFile("<filename>", completion: { data in })
```

### Remove log
```
AppboosterClientLogger.removeDefaultLogFile()
```
or
```
AppboosterClientLogger.removeLogFile("<filename>")
```

### Open logs list
```
AppboosterClientLogger.openLogs(from: <viewController>)
```
or you can use one of our predefined ways of logs list opening:
```
AppboosterClientLogger.add5TapsGestureToView(<view>) // 1
AppboosterClientLogger.add2SecondsPressGestureToView(<view>) // 2
```
or you can inherit some of your `UIViewController`'s from `AppboosterClientLoggerShakeViewController` and just make shake motion on your iPhone or simulator.

### Default log file lifecycle
Each activation of client logger:
1) delete previous default log file ("PrevDefaultLog") (if it exists)
2) rename default log file ("DefaultLog") (if it exists) to previous default log file ("PrevDefaultLog")



==================================================

You can see the example of usage in the attached project in the `AppboosterClientLoggerExample/` directory.


