
import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    //Test
    let prueba: [Int] = [0,1,2]

    //Data IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seachTextField: UITextField!
    
    
    
    
    //Data Arrays
    var objetos: [[String: Any]] = [[:]]
    var nombres: [Any] = []
    var precios: [Any] = []
    var ubicaciones: [Any] = []
    var imagenes: [String] = []


    
    


    //Need This
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Specify TableView Sources
        tableView.delegate = self
        tableView.dataSource = self
        //seachTextField.text = ""
        //obtenerDatos()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Load new Data
    @IBAction func goButton(_ sender: Any) {
        obtenerDatos()
       
    }
    
    //Rock and Roll of code
    func obtenerDatos(){
        //Reinitialize
        objetos.removeAll()
        var jsonObject: Dictionary <String, Any> = [:]
        var jsonProduct: Dictionary <String, Any> = [:]
        var jsonProduct2: Dictionary <String, Any> = [:]
        var jsonProduct3: [[String: Any]] = [["":""]]

        
    //New Api
    let firstPart: String = "https://shopappqa.liverpool.com.mx/appclienteservices/services/v3/plp?search-string="
    let secondPart: String = "&page-number=1"
    
    let finalApi = firstPart + "\(seachTextField.text!)" + secondPart
    print(finalApi)
    
    //Request info API
    let API = request(finalApi).responseJSON { (datas) in
        
        //Frames
        if let jsonData = datas.result.value{
            
            
            
            //Split data into multiples dictionaries
            jsonObject = jsonData as! Dictionary<String, Any>
            jsonProduct = jsonObject["status"] as! Dictionary<String, Any>
            jsonProduct2 = jsonObject["plpResults"] as! Dictionary<String, Any>
            jsonProduct3 = jsonProduct2["records"] as! [[String: Any]]
            
            if(jsonProduct3.count > 0){
            
                //Extract data from dictionaries
                for elements in 0...jsonProduct3.count-1{
                    print("El elemento", elements, "\(jsonProduct3[elements])")
                    self.objetos.append(jsonProduct3[elements])
                    
                    let productListName = jsonProduct3[elements]["productDisplayName"]! as Any
                    let listPrice = jsonProduct3[elements]["maximumListPrice"]! as Any
                    let minimumPromoPrice = jsonProduct3[elements]["productId"]! as Any
                    let smImage: String = jsonProduct3[elements]["lgImage"]! as! String
                    
                    
                    //print(elements, nombre)
                    self.nombres.append(productListName)
                    self.precios.append(listPrice)
                    self.ubicaciones.append(minimumPromoPrice)
                    self.imagenes.append(smImage)
                    
                }
                
            }
            
            else{
                let alert = UIAlertController(title: "Error", message: "No encontramos este producto", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            
            
            self.tableView.reloadData()
            
            

        }
    }
        
}
    
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nombres.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as! ViewControllerTableViewCell
        
        
    
        cell.myName.text = "\(nombres[indexPath.row])"
        cell.oldPrice.text = "\(precios[indexPath.row]) MXN"
        cell.newPrice.text = "ID: \(ubicaciones[indexPath.row])"
        
        //Convert image
        DispatchQueue.global(qos: .background).async {
            let url = URL(string:(self.imagenes[indexPath.row]))
            let secondUrl = URL(string:("https://ss634.liverpool.com.mx/lg/1087818248.jpg"))
            let data = try? Data(contentsOf: url!)
            let secondData = try? Data(contentsOf: secondUrl!)
            let image: UIImage = UIImage(data: data ?? secondData!)!
            DispatchQueue.main.async {
                cell.imageView?.image = image
            }
        }

        return cell
        
    }
    //Size of table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
   





}

