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
        fetchCoreData { x in
            print(x!)
            if let words = x{
                for w in words{
                    print(w.meaning!)
                    print(w.word!)
                    self.words.append(w.word!)
                }
            }
        }
        
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
                addCoreData(word: self.wordTextField.text!, meaning: x.definition)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(self.words)
        print(self.words[indexPath.row])
        fetchMeaning(completionHandler: {
            dictonaryArray in
            print(dictonaryArray)
            let x = dictonaryArray[0].meanings[0].definitions[0]
            print(x.definition)
            DispatchQueue.main.async {
                self.outputLabel.text = x.definition
            }
            
        }, word:self.words[indexPath.row])
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
                let dictonaryArray = try JSONDecoder().decode([Dictonary].self, from: data)
                print(dictonaryArray)
                completionHandler(dictonaryArray)

            } catch let jsonErr {
                print("Error printing json data", jsonErr)
            }
            
        }
        
    })
    task.resume()
   
}


func fetchMeaning2(completionHandler: @escaping ([Dictonary])-> Void , word: String) {
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
                let dictonaryArray = try JSONDecoder().decode([Dictonary].self, from: data)
                print(dictonaryArray)
                completionHandler(dictonaryArray)

            } catch let jsonErr {
                print("Error printing json data", jsonErr)
            }
            
        }
        
    })
    task.resume()
   
}


func addCoreData(word: String, meaning: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let words = Word(context: context)
    words.word = word
    words.meaning = meaning
    do {
        try context.save()
    } catch {
        print("error-Saving data")
    }
}

func fetchCoreData(onSuccess: @escaping ([Word]?) -> Void) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        let items = try context.fetch(Word.fetchRequest()) as? [Word]
        onSuccess(items)
    } catch {
        print("error-Fetching data")
    }
}
