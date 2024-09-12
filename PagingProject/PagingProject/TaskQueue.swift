actor TaskQueue {
    private var tasks = [() async -> Void]()
    private var isRunning = false
    private var ongoingTasks = Set<Task<Void, Never>>()
    
    func addTask(_ task: @escaping () async -> Void) {
        tasks.append(task)
        runNextTaskIfNeeded()
    }
    
    func cancelTasks() {
        for task in ongoingTasks {
            task.cancel()
        }
        tasks.removeAll()
    }

    private func runNextTaskIfNeeded() {
        guard !isRunning, !tasks.isEmpty else { return }
        
        isRunning = true
        let task = Task {
            let nextTask = tasks.removeFirst()
            await nextTask()
            
            isRunning = false
            runNextTaskIfNeeded()
        }
        ongoingTasks.insert(task)
    }
}
