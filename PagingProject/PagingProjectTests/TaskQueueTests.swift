@testable import PagingProject
import XCTest

final class TaskQueueTests: XCTestCase {
    private var taskQueue: TaskQueue!
    override func setUp() {
        super.setUp()
        taskQueue = TaskQueue()
    }
    
    override func tearDown() {
        taskQueue = nil
        super.tearDown()
    }

    func testSequentialTaskExecution() async throws {
        let expectation1 = expectation(description: "Task 1 executed")
        let expectation2 = expectation(description: "Task 2 executed")
        let expectation3 = expectation(description: "Task 3 executed")
        
        var taskOrder = [Int]()
        
        await taskQueue.addTask {
            taskOrder.append(1)
            expectation1.fulfill()
        }
        
        await taskQueue.addTask {
            taskOrder.append(2)
            expectation2.fulfill()
        }
        
        await taskQueue.addTask {
            taskOrder.append(3)
            expectation3.fulfill()
        }
        
        await fulfillment(of: [expectation1, expectation2, expectation3])
        XCTAssertEqual(taskOrder, [1, 2, 3], "Tasks should execute in sequential order")
    }
}
