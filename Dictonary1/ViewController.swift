//
//  ViewController.swift
//  Dictonary1
//
//  Created by Pranaya on 8/13/24.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    var words = [String]()

    @IBOutlet weak var wordTextField: UITextField!
    
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var wordMeaningsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wordTextField.text = "autism"
        // Do any additional setup after loading the view.
    }

    @IBAction func searchButtonPressed(_ sender: Any) {
        fetchMeaning(completionHandler: {
            w in
            print(w)
            let x = w[0].meanings[0].definitions[0]
            print(x.definition)
            DispatchQueue.main.async {
                self.outputLabel.text = x.definition
                self.words.append(self.wordTextField.text!)
                self.wordMeaningsTable.reloadData()
            }
            
        }, word: wordTextField.text!)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.words.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let aCell = self.wordMeaningsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        aCell.meaningLabel.text = self.words[indexPath.row]
        return aCell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
}
func fetchMeaning(completionHandler: @escaping ([Dictonary])-> Void , word: String) {
    let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/" + word)!
    let task = URLSession.shared.dataTask(with: url , completionHandler: { (data, response, error) in
        if let error = error{
            print("error fetching meaning: \(error)")
            return
        }
        guard let httpResponse = response as?
                HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else{
            print("error in response: \(String(describing: response))")
            return
        }
        if let data = data
            //,let dictonary = try?JSONDecoder().decode([Dictonary].self, from: data)
        {
            print(String(data: data , encoding: .utf8)!)
            do {
                let dictonary = try JSONDecoder().decode([Dictonary].self, from: data)
                print(dictonary)
                completionHandler(dictonary)

            } catch let jsonErr {
                print("Error printing json data", jsonErr)
            }
            
        }
        
    })
    task.resume()
   
}


