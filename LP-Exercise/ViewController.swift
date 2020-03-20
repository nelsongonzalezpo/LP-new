
import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seachTextField: UITextField!
    
    var objetos: [[String: Any]] = [[:]]
    var nombres: [Any] = []
    var precios: [Any] = []
    var ubicaciones: [Any] = []
    var imagenes: [String] = []
    var arregloBusqueda: NSMutableArray = []
    var jsonObject: Dictionary <String, Any> = [:]
    var jsonProduct: Dictionary <String, Any> = [:]
    var jsonProduct2: Dictionary <String, Any> = [:]
    var jsonProduct3: [[String: Any]] = [["":""]]


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
    
    func tableView2(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBusqueda") as! ViewControllerTableViewCell
        
        for elements in arregloBusqueda{
            cell.myName.text = elements as? String ?? ""
        }

        return cell
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    @IBAction func goButton(_ sender: Any) {
        obtenerDatos()
    }
    
    
    func obtenerDatos(){
        //Reinitialize
        
        
        let firstPart: String = "https://shopappqa.liverpool.com.mx/appclienteservices/services/v3/plp?search-string="
        let secondPart: String = "&page-number=1"
        
        let finalApi = firstPart + "\(seachTextField.text!)" + secondPart
        print(finalApi)
        
        arregloBusqueda.add(seachTextField.text as Any)
        
        print("arregloBusqueda")
        print(arregloBusqueda)
        
        _ = request(finalApi).responseJSON { (datas) in
            
            if let jsonData = datas.result.value{
                
                self.jsonObject = jsonData as! Dictionary<String, Any>
                self.jsonProduct = self.jsonObject["status"] as! Dictionary<String, Any>
                self.jsonProduct2 = self.jsonObject["plpResults"] as! Dictionary<String, Any>
                self.jsonProduct3 = self.jsonProduct2["records"] as! [[String: Any]]
                
                if(self.jsonProduct3.count > 0){
                    
                    for elements in 0...self.jsonProduct3.count-1{
//                        print("El elemento", elements, "\(jsonProduct3[elements])")
                        self.objetos.append(self.jsonProduct3[elements])
                        
                        let productListName = self.jsonProduct3[elements]["productDisplayName"]! as Any
                        let listPrice = self.jsonProduct3[elements]["maximumListPrice"]! as Any
                        let minimumPromoPrice = self.jsonProduct3[elements]["productId"]! as Any
                        let smImage: String = self.jsonProduct3[elements]["lgImage"]! as! String
                        
                        
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
                
                self.objetos.removeAll()
                self.jsonObject.removeAll()
                self.jsonProduct.removeAll()
                self.jsonProduct2.removeAll()
                self.jsonProduct3.removeAll()
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    
}

