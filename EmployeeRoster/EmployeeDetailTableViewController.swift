
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeTableViewDelegate {
   
    
   
    

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    var employee: Employee?
    var employeeType: EmployeeType?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "dd/MM/yy"
//        let maxDateString = "13/06/2005"
//        let maxDate = dateformatter.date(from: maxDateString)  // max date(can't choose date occurring after)
        let maxDate = Date(timeInterval: -504576000, since: Date()) //2005
        let minDate = Date(timeInterval: -2049840000, since: Date()) //1956
        dobDatePicker.maximumDate = maxDate
        dobDatePicker.minimumDate = minDate
        dobDatePicker.date = maxDate
    }
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = dateFormatter.string(from: employee.dateOfBirth)
            dobLabel.textColor = .black
            employeeTypeLabel.text = employee.employeeType.description
            employeeTypeLabel.textColor = .black
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false && employeeTypeLabel.text?.contains("Please") == false && dobLabel.text?.contains("Please") == false 
        saveBarButtonItem.isEnabled = shouldEnableSaveButton
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        guard let employeeType = employeeType else {
            return
        }

        
        let employee = Employee(name: name, dateOfBirth: dobDatePicker.date, employeeType: employeeType)
        delegate?.employeeDetailTableViewController(self, didSave: employee)
        print(employee)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
    }

    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // indexpath for date Picker
    let dobPickerIndexPath = IndexPath(row: 2, section: 0)
    var isEditingBirthday: Bool = false{
        didSet{
            dobDatePicker.isHidden = !isEditingBirthday // sets visibility of dobDatePicker
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isEditingBirthday == false && indexPath == dobPickerIndexPath{
            return 0
        }
       return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dobLabelIndexPath = IndexPath(row: 1, section: 0)
        
        if indexPath == dobLabelIndexPath{
            isEditingBirthday.toggle()
        }
        let dob = dobDatePicker.date
        dobLabel.textColor = .black
        dobLabel.text = dateFormatter.string(from: dob)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func dobPickerValueChnaged(_ sender: UIDatePicker) {
        dobLabel.text = dateFormatter.string(from: dobDatePicker.date)
    }
    
    func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType) {
        self.employeeType = employeeType
        employeeTypeLabel.text = String(describing: employeeType)
        employeeTypeLabel.textColor = .black
        updateSaveButtonState()
    }
    
    @IBSegueAction func showEmployeeTypes(_ coder: NSCoder) -> EmployeeTypeTableViewController? {
        let EmployeeTypeController = EmployeeTypeTableViewController(coder: coder)
        EmployeeTypeController?.delegate = self
       
        
        return EmployeeTypeController
    }
    
    
    

}
