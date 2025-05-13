import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var mealSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mealCaloriesLabel: UILabel!  // Yeni label için outlet
    
    // Yiyecek verilerini sabit olarak alıyoruz
    var foodList: [FoodItem] = [
        FoodItem(name: "Elma", calories: 52),
        FoodItem(name: "Muz", calories: 89),
        FoodItem(name: "Yumurta", calories: 68),
        FoodItem(name: "Tavuk Göğsü", calories: 165),
        FoodItem(name: "Peynir", calories: 113)
    ]
    
    // Kullanıcı tarafından belirlenen kalori limitleri (başlangıçta varsayılan değerler)
    var calorieLimits: [MealType: Int] = [
        .sabah: 400,  // Sabaha 400 kcal (başlangıç değeri)
        .ogle: 600,   // Öğleye 600 kcal (başlangıç değeri)
        .aksam: 700   // Akşama 700 kcal (başlangıç değeri)
    ]
    
    // Öğün bazlı seçilen yiyecekleri tutacağız
    var selectedFoodsByMeal: [MealType: [FoodItem]] = [
        .sabah: [],
        .ogle: [],
        .aksam: []
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        
        setupSegmentedControl()
        updateTotalCalories()
        updateMealCalories() // Yeni öğün kalorilerini de güncelleyerek başlatıyoruz
    }
    
    // Segmented Control'u düzenliyoruz
    func setupSegmentedControl() {
        mealSegmentedControl.removeAllSegments()
        for (index, meal) in MealType.allCases.enumerated() {
            mealSegmentedControl.insertSegment(withTitle: meal.rawValue, at: index, animated: false)
        }
        mealSegmentedControl.selectedSegmentIndex = 0
    }
    
    // Aktif öğünü belirlemek için
    func currentMeal() -> MealType {
        return MealType.allCases[mealSegmentedControl.selectedSegmentIndex]
    }
    
    // Toplam kaloriyi güncelliyoruz (Tüm öğünler için)
    func updateTotalCalories() {
        var totalCalories = 0
        for (meal, foods) in selectedFoodsByMeal {
            totalCalories += foods.reduce(0) { $0 + $1.calories }
        }
        totalCaloriesLabel.text = "Toplam Kalori: \(totalCalories) kcal"
    }
    
    // Belirli bir öğün için mevcut kaloriyi hesaplıyoruz
    func caloriesForMeal(_ meal: MealType) -> Int {
        return selectedFoodsByMeal[meal]?.reduce(0) { $0 + $1.calories } ?? 0
    }
    
    // Öğün için toplam kaloriyi güncelleyip mealCaloriesLabel'da gösteriyoruz
    func updateMealCalories() {
        let currentMealType = currentMeal()
        let mealCalories = caloriesForMeal(currentMealType)
        mealCaloriesLabel.text = "\(currentMealType.rawValue) Öğünü: \(mealCalories) kcal"
    }
    
    // Kullanıcı tarafından öğün kalori limiti belirlemek için
    @IBAction func setCalorieLimitTapped(_ sender: UIButton) {
        // Kullanıcıya bir uyarı gösterelim
        let meal = currentMeal()
        let limitAlert = UIAlertController(title: "\(meal.rawValue) Öğünü İçin Kalori Limiti Belirleyin",
                                           message: "Bu öğün için kalori limitini girin:",
                                           preferredStyle: .alert)
        
        // Uyarıya bir metin alanı ekleyelim
        limitAlert.addTextField { (textField) in
            textField.placeholder = "Kalori limiti"
            textField.keyboardType = .numberPad
        }
        
        // "Tamam" butonu ekleyelim
        limitAlert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
            if let textField = limitAlert.textFields?.first, let limitText = textField.text, let limit = Int(limitText) {
                self.calorieLimits[meal] = limit
                self.showAlert("\(meal.rawValue) için yeni kalori limiti \(limit) kcal olarak belirlendi.")
            }
        }))
        
        // "İptal" butonu ekleyelim
        limitAlert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        // Uyarıyı gösterelim
        present(limitAlert, animated: true)
    }
    
    // Yiyecek ekleme butonuna basıldığında
    @IBAction func addFoodButtonTapped(_ sender: UIButton) {
        // Seçilen yiyecek var mı diye kontrol edelim
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            showAlert("Lütfen bir yiyecek seçin!")
            return
        }
        
        let selectedFood = foodList[selectedIndexPath.row]
        let meal = currentMeal()  // Hangi öğün seçildiğini alıyoruz
        
        let currentCalories = caloriesForMeal(meal)
        let mealLimit = calorieLimits[meal] ?? 0
        
        if currentCalories + selectedFood.calories > mealLimit {
            showAlert("\(meal.rawValue) öğününde kalori limiti aşılıyor! (Limit: \(mealLimit) kcal)")
            return
        }
        
        // Yiyeceği seçilen öğüne ekliyoruz
        selectedFoodsByMeal[meal]?.append(selectedFood)
        
        // TableView'i güncelliyoruz
        tableView.deselectRow(at: selectedIndexPath, animated: true)
        updateTotalCalories()
        updateMealCalories() // Yeni öğün kalorilerini de güncelliyoruz
        tableView.reloadData()
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Tabloyu doldurmak için veri sayısını belirliyoruz
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }

    // Tablo hücresini yapılandırıyoruz
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        let food = foodList[indexPath.row]
        cell.textLabel?.text = "\(food.name) - \(food.calories) kcal"
        return cell
    }
}
