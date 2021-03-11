//
//  INFOViewController.swift
//  SkillTest
//
//  Created by jeena azeez on 08/03/2021.
//

import UIKit

class INFOViewController: UIViewController {
    
    @IBOutlet weak var descriptionCurrency:UILabel!
    @IBOutlet weak var CodeCurrency:UILabel!

    @IBOutlet weak var EurAmount:UILabel!
    @IBOutlet weak var EurDate:UILabel!
    
    @IBOutlet weak var image1:UIImageView!
    @IBOutlet weak var image2:UIImageView!

    @IBOutlet weak var myView:UIView!



    var DateINFO  = UserDefaults.standard.value(forKey: "DateTransfor")
    var CurrencyFlagLink = UserDefaults.standard.value(forKey: "flags")
    var EURBASE = UserDefaults.standard.value(forKey: "EurAmount")
    var CurrencyRate = UserDefaults.standard.value(forKey: "rates")
    var CurrencyDescription = UserDefaults.standard.value(forKey: "Description")
    var cuurencyCode = UserDefaults.standard.value(forKey: "currencyCode")
    
    
    override func viewDidLoad() {
       

       
        myView.layer.cornerRadius = 10
        myView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        myView.layer.shadowRadius = 10
        myView.layer.shadowOpacity = 5
        myView.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        
        descriptionCurrency.text = String(describing:CurrencyDescription!)
        CodeCurrency.text = String(describing: CurrencyRate!)
        EurAmount.text = String(describing: EURBASE!)
        EurDate.text = String(describing: DateINFO!)

        
        do {
            // download images from URLs
            let url = URL(string: CurrencyFlagLink as! String)!
            let data = try Data(contentsOf: url)
            image1.image = UIImage(data: data)
            image2.image = UIImage(data: data)
        }
        catch{
            print(error)
        }
       
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
    dismiss(animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
