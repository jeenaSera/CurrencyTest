//
//  ViewController.swift
//  SkillTest
//
//  Created by jeena azeez on 08/03/2021.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var tableview:UITableView! // my table view
    
    // arrays for symbols json file
    var symbols:[String:Any] = [:] // for json valuse => Symbols => currencies code and currencies description
    var symbolKey:[String] = [] // for currencies code
    var symbolAKey:[Any] = [] // for currencies description
    var currencyCode:[String] = [] // for currencies code after sort
    var CurrencyDescription:[Any] = [] // for currencies description after sort depending on currencies code
    
    // arrays for flags
    
    var flagJSON:[String:Any] = [:] // for json values => currencies code and images of flags
    var FlagCodes:[String] = []
    var FlagLinks:[Any] = [] // images of falgs
    
    var flagCodeFilter:[String] = [] //
    var flaglinkFilteres:[Any] = [] // i will sort them depending on flag codes(currencies key) to be sorts as currencies code and currencies description in fetch data
    
    //arrays for rates
    var rates:[String:Any] = [:]
    var ratesKey:[String] = []
    var ratesAKey:[Any] = []
    
    var rateskeyFilter:[String] = []
    var ratesAkeyFilter:[Any] = []
    
    var DateTrasfer:String = ""
    var EurAmount:Any = ""
    
    
    
    
    override func viewDidLoad() {
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = 80
        
        
        // Get flagLinks with code
            Flags { (mydata1, error) in
             
            self.flagJSON = mydata1!["flags"] as! [String:Any] // Get flags from API
            self.FlagCodes.append(contentsOf: Array(self.flagJSON.keys)) // for currencies code
            self.FlagLinks.append(contentsOf: Array(self.flagJSON.values)) // currencies flag
            
            
            self.flagCodeFilter = self.FlagCodes.sorted { $0 < $1 } //sort currencies code form a to z

            for i in 0 ..< self.flagCodeFilter.count
            {
                let indexOfA = self.FlagCodes.firstIndex(of: self.flagCodeFilter[i]) // sort currencies flag depend on currencies Code
                let lastID:Int = Int(indexOfA!) // get index of value from flageCodes to take same element from flag links
                self.flaglinkFilteres.append(self.FlagLinks[lastID])
            }
                DispatchQueue.main.async {
                    self.tableview.reloadData() // reload data for tableview
                }
            }
            
        //Get currency code and code description
                Symbols { [self] (myData, error) in
            self.symbols = myData!["symbols"] as! [String : Any] // get symbols from API
            self.symbolKey.append(contentsOf: Array(self.symbols.keys)) // currencies code
            self.symbolAKey.append(contentsOf: Array(self.symbols.values)) // currencies description
            

            self.currencyCode = self.symbolKey.sorted { $0 < $1 } // sort from a to z, due to evey time call the API it shows different sort and I sorted to control the flag images with it.
                
            for i in 0 ..< self.currencyCode.count
            {
                let indexOfA = self.symbolKey.firstIndex(of: self.currencyCode[i]) // sort currencies description depend on currencies Code
                let lastID:Int = Int(indexOfA!)
                self.CurrencyDescription.append(self.symbolAKey[lastID])
            }
            
            DispatchQueue.main.async {
                self.tableview.reloadData() // reload data for tableview
            }
           }
        
                Rates { (mydata2, error) in
            self.rates = mydata2!["rates"] as! [String:Any]  // get rates from API
            self.ratesKey.append(contentsOf: Array(self.rates.keys))
            self.ratesAKey.append(contentsOf: Array(self.rates.values))
            
            self.DateTrasfer = mydata2!["date"] as! String // take date of currencies transactions
            self.EurAmount = self.rates["EUR"] as! Any // take Eur amout (base)
            
            
            self.rateskeyFilter = self.ratesKey.sorted { $0 < $1 }
            
            for i in 0 ..< self.rateskeyFilter.count
            {
                let indexOfA = self.ratesKey.firstIndex(of: self.rateskeyFilter[i]) // sort currencies flag depend on currencies Code
                let lastID:Int = Int(indexOfA!)
                self.ratesAkeyFilter.append(self.ratesAKey[lastID])
            }

            DispatchQueue.main.async {
                self.tableview.reloadData() // reload data for tableview
            }
            
        }
        
        
        
        super.viewDidLoad()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        UserDefaults.standard.set(currencyCode[indexPath.row], forKey: "currencyCode")
        UserDefaults.standard.set(flaglinkFilteres[indexPath.row], forKey: "flags")
        UserDefaults.standard.set(CurrencyDescription[indexPath.row], forKey: "Description")
        UserDefaults.standard.set(DateTrasfer, forKey: "DateTransfor")
        UserDefaults.standard.set(EurAmount, forKey: "EurAmount")
        UserDefaults.standard.set(ratesAkeyFilter[indexPath.row], forKey: "rates")
        
        performSegue(withIdentifier: "push", sender: self)
    }
    var count = 0
    // number of row in tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( flaglinkFilteres.isEmpty || currencyCode.isEmpty || CurrencyDescription.isEmpty )
        {
            count = 0
        }
        else
        {
            count = flaglinkFilteres.count
        }
       return count
    }
    
    //value for each row => cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! cell
       
        do {
            // download images from URLs
            let url = URL(string: flaglinkFilteres[indexPath.row] as! String)!
            let data = try Data(contentsOf: url)
            cell.image1.image = UIImage(data: data)
        }
        catch{
            print(error)
        }
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.label1.text = currencyCode[indexPath.row] + " : "
        cell.label2.text = CurrencyDescription[indexPath.row] as! String
        
        return cell
        
    }
    
}

extension ViewController {
   
    
    
    // fetch Data for currencies code and currency descriptions
    func Symbols(completion: @escaping ([String:Any]?, Error?) -> Void) {
        
        let url = URL(string: "http://data.fixer.io/api/symbols?access_key=a8384217b73caedf1ccdb3a01aff7fe3")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    completion(array, nil) // completion return array => json data

                   
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    // fetch data for currencies code and flags
    func Flags(completion: @escaping ([String:Any]?, Error?) -> Void) {
        let url = URL(string: "http://bdo.pqv.mybluehost.me/CurF6.json?nocache=1")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    completion(array, nil)
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    // fetch data for rates
    func Rates(completion: @escaping ([String:Any]?, Error?) -> Void) {
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=a8384217b73caedf1ccdb3a01aff7fe3")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    completion(array, nil)
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }

}
