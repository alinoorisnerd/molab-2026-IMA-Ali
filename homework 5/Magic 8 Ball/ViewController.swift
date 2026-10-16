import UIKit

class ViewController: UIViewController {
    
    let ballArray = [#imageLiteral(resourceName: "ball4"), #imageLiteral(resourceName: "ball1"), #imageLiteral(resourceName: "ball1"), #imageLiteral(resourceName: "ball4"), #imageLiteral(resourceName: "ball2")]
    
    // interface builder outlet for controlling the screen from the code
    @IBOutlet weak var ballImage: UIImageView!
    
    // MARK: - Persistent storage
    private let defaults = UserDefaults.standard
    private let lastIndexKey = "lastBallIndex"
    private let lastDateKey = "lastBallDate"
    private let reuseWindow: TimeInterval = 120   // 2 minutes
    
    private var currentIndex = 0
    
    // interface builder action for controlling the code / logic from the screen
    @IBAction func runSuggestion(_ sender: Any) {
        let index = Int.random(in: 0..<ballArray.count)
        show(index)
        saveResult(index)
    }
    
    @IBAction func saveLast(_ sender: Any) {
        // Manually save whatever is currently on screen (restarts the 2-minute window)
        saveResult(currentIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        show(0)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if let savedIndex = recentSavedIndex() {
                show(savedIndex)          // shaken within 2 minutes → same answer
            } else {
                runSuggestion(self)       // older than 2 minutes → new answer (and save it)
            }
        }
    }
    
    
    private func show(_ index: Int) {
        currentIndex = index
        ballImage.image = ballArray[index]
    }
    
    private func saveResult(_ index: Int) {
        defaults.set(index, forKey: lastIndexKey)
        defaults.set(Date(), forKey: lastDateKey)
    }
    
    
    private func recentSavedIndex() -> Int? {
        guard let savedDate = defaults.object(forKey: lastDateKey) as? Date,
              Date().timeIntervalSince(savedDate) < reuseWindow,
              defaults.object(forKey: lastIndexKey) != nil else {
            return nil
        }
        let index = defaults.integer(forKey: lastIndexKey)
        return ballArray.indices.contains(index) ? index : nil
    }
}
