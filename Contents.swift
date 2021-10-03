import UIKit

// Swift "equivalent" to an interface
protocol Receiver
{
    func receiveThis()
}

// Constructor Dependency Injection
// Class taking a Receiver type and it must be set through
// the initializer init()
class Sender
{
    private var receiver: Receiver
    
    init(r: Receiver)
    {
        receiver = r
    }
    
    func doSomething()
    {
        receiver.receiveThis()
    }
}

class SpecificReceiver: Receiver
{
    func receiveThis() {
        // do something interesting.
    }
}






// BusinessRule Gateway Example
protocol Item
{
    func makeChanges()
}

class Something: Item
{
    func makeChanges() {
        // do something.
    }
}

protocol BusinessRuleGateway
{
    func getSomething(id: String) -> Item
    func startTransaction()
    func saveSomething(thing: Item)
    func endTransaction()
}

class MySqlBusinessRuleGateway: BusinessRuleGateway
{
    func getSomething(id: String) -> Item {
        // use MySql to get a thing.
        let thing = Something()
        return thing
    }
    
    func startTransaction() {
        // start something
    }
    
    func saveSomething(thing: Item) {
        // save something.
    }
    
    func endTransaction() {
        // end transaction.
    }
}

class BusinessRule
{
    private var gateway: BusinessRuleGateway
    
    init(gateway: BusinessRuleGateway)
    {
        self.gateway = gateway
    }
    
    func execute(id: String)
    {
        gateway.startTransaction()
        let thing = gateway.getSomething(id: id)
        thing.makeChanges()
        gateway.saveSomething(thing: thing)
        gateway.endTransaction()
    }
}

protocol Engine {
    func forward(currentSpeed: Double) -> Double
    func reverse()
    func decelerate(currentSpeed: Double) -> Double
}

class RaceCarEngine: Engine {
    let maxSpeed = 260.0
    let rate = 20.0
    let maxReverseSpeed = 35.0
    let decelerationSpeed = 30.0
    let minSpeed = 0.0
    
    func forward(currentSpeed: Double) -> Double {
        return currentSpeed >= maxSpeed ? maxSpeed : Double(maxSpeed / rate) + currentSpeed
    }
    
    func reverse() {
        // go in reverese
    }
    
    func decelerate(currentSpeed: Double) -> Double {
        // slow down at given rate
        return currentSpeed <= minSpeed ? minSpeed : currentSpeed - Double(maxSpeed / decelerationSpeed)
    }
}

class SportsCarEngine: Engine {
    let maxSpeed = 200.0
    let rate = 10.0
    let maxReverseSpeed = 35.0
    let decelerationSpeed = 20.0
    let minSpeed = 0.0
    
    func forward(currentSpeed: Double) -> Double {
        return currentSpeed >= maxSpeed ? maxSpeed : Double(maxSpeed / rate) + currentSpeed
    }
    
    func reverse() {
        // go in reverese
    }
    
    func decelerate(currentSpeed: Double) -> Double {
        // slow down at given rate
        return currentSpeed <= minSpeed ? minSpeed : currentSpeed - Double(maxSpeed / decelerationSpeed)
    }
}

class Vehicle {
    var engine: Engine
    var carType: String
    var currentSpeed = 0.0
    var brakeApplied = false
    var acceleratorApplied = false
    
    var timer = Timer()
    
    init(engine: Engine, carType: String) {
        self.engine = engine
        self.carType = carType
    }
    
    func accelerate() {
        self.acceleratorApplied = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {timer in
            
            if (self.brakeApplied) {
                timer.invalidate()
                self.acceleratorApplied = false
            } else {
                self.currentSpeed = self.engine.forward(currentSpeed: self.currentSpeed)
                print("\(self.carType)'s current speed: \(self.currentSpeed)")
            }
        }
    }
    
    func brake() {
        self.brakeApplied = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {timer in
            
            if (self.acceleratorApplied == true) {
                timer.invalidate()
                self.brakeApplied = false
            } else {
                self.currentSpeed = self.engine.decelerate(currentSpeed: self.currentSpeed)
                print("\(self.carType)'s current speed: \(self.currentSpeed)")
            }
        }
    }
}

var timeToSlowDown = 10
let raceCar = Vehicle(engine: RaceCarEngine(), carType: "Race Car")
raceCar.accelerate()

let sportsCar = Vehicle(engine: SportsCarEngine(), carType: "Sports Car")
sportsCar.accelerate()


Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {timer in
    timeToSlowDown -= 1
    if (timeToSlowDown == 0) {
        print("\n\n\n\n\n")
        raceCar.brake()
        sportsCar.brake()
    }
}

