//
//  ViewController.swift
//  HW22
//
//  Created by Максим Громов on 21.09.2024.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    let cities = ["Moscow", "Saint Petersburg", "Kazan", "Nizhny Novgorod", "Krasnodar"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityLabel.text = cities[row]
    }
    
    lazy var messageButton = UIButton()
    lazy var stackView = UIStackView()
    lazy var picker = UIPickerView()
    lazy var cityLabel = UILabel()
    lazy var imageView = UIImageView()
    lazy var imageButton = UIButton()
    lazy var notification = UIView()
    lazy var notification_label = UILabel()
    var notificationTop: NSLayoutConstraint?
    
    
    func showNotification(text: String) async{
        notification_label.text = text
        let queue = DispatchQueue(label: "notification_queue")
        queue.async {
            print("showing")
            DispatchQueue.main.async{
                self.notificationTop?.constant = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            sleep(5)
            DispatchQueue.main.async{
                self.notificationTop?.constant = -200
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            print("done")
        }
    }
    
    @objc func showMessage(){
        let alert = UIAlertController(title: "Сообщение", message: "Привет, это тестовое сообщение", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true)
            Task {
                await self.showNotification(text: "Спасибо")
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.alignment = .center
        stackView.axis = .vertical
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 400)
        ])
        messageButton.setTitle("Показать сообщение", for: .normal)
        messageButton.setTitleColor(.systemBlue, for: .normal)
        stackView.addArrangedSubview(messageButton)
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        messageButton.addTarget(self, action: #selector(showMessage), for: .touchUpInside)
        
        stackView.addArrangedSubview(cityLabel)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cityLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        cityLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        cityLabel.textAlignment = .center
        cityLabel.text = "Выберите город"
        
        stackView.addArrangedSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        picker.delegate = self
        picker.dataSource = self
        
        stackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.backgroundColor = .systemGray5
        
        stackView.addArrangedSubview(imageButton)
        imageButton.setTitle("Выбрать фотографию", for: .normal)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        imageButton.setTitleColor(.systemBlue, for: .normal)
        
        self.view.addSubview(notification)
        notification.translatesAutoresizingMaskIntoConstraints = false
        notification.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        notification.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        notification.heightAnchor.constraint(equalToConstant: 80).isActive = true
        notification.backgroundColor = .systemGray4
        notification.layer.cornerRadius = 10
        notification.layer.shadowColor = UIColor.black.cgColor
        notification.layer.shadowOffset = .zero
        notification.layer.shadowOpacity = 0.5
        notificationTop = notification.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -200)
        notificationTop?.isActive = true
        
        notification_label.font = .systemFont(ofSize: 32, weight: .semibold)
        notification.addSubview(notification_label)
        notification_label.translatesAutoresizingMaskIntoConstraints = false
        notification_label.topAnchor.constraint(equalTo: notification.topAnchor).isActive = true
        notification_label.bottomAnchor.constraint(equalTo: notification.bottomAnchor).isActive = true
        notification_label.leadingAnchor.constraint(equalTo: notification.leadingAnchor).isActive = true
        notification_label.trailingAnchor.constraint(equalTo: notification.trailingAnchor).isActive = true
        notification_label.textAlignment = .center
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            imageView.image = image
        }
        picker.dismiss(animated: true)
    }
    @objc func imageButtonTapped(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

}

#Preview{
    ViewController()
}
