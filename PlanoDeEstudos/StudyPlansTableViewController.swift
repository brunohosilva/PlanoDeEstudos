import UIKit

final class StudyPlansTableViewController: UITableViewController {

    // MARK: - Properties
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }()
	private let studyManager = StudyManager.shared
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onConfirmed),
                                               name: NSNotification.Name(rawValue: .confirmed),
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Methods
    
    @objc func onConfirmed(notification: Notification) {
        if let id = notification.userInfo?["id"] as? String {
            print("VEIO O ID???? --->", id)
            
            StudyManager.shared.setPlanDone(id: id)
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studyManager.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let studyPlan = studyManager.getStudyPlanAt(indexPath)
        cell.textLabel?.text = studyPlan.section
        cell.detailTextLabel?.text = dateFormatter.string(from: studyPlan.date)
        cell.backgroundColor = studyPlan.done ? .green : .white
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            studyManager.removePlan(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
