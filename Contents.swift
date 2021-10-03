import UIKit

var greeting = "Hello, playground"

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
