//
//  ViewController.swift
//  WeatherApplication
//
//  Created by admin on 22/12/2021.
//

import UIKit

class WeatherViewController: UIViewController {
    
    var currentWeather: Current?
    var hourlyWeatherList = [Current]()
    var dailyWeatherList = [Daily]()
    var weatherIcons = [String: UIImage]()

    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        dailyCollectionView.dataSource = self
        dailyCollectionView.delegate = self
        gettingWeatherData()
    }

    func gettingWeatherData() {
        APIModel.getWeatherData { data, response, error in
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(WeatherDataModel.self, from: data!)
                self.currentWeather = decoded.current
                self.hourlyWeatherList = decoded.hourly
                self.dailyWeatherList = decoded.daily
                DispatchQueue.main.async { [self] in
                    hourlyCollectionView.reloadData()
                    dailyCollectionView.reloadData()
                }
            } catch {
                print("Failed to decode JSON \(error)")
            }
        }
    }

}

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case hourlyCollectionView:
            return hourlyWeatherList.count
        case dailyCollectionView:
            return dailyWeatherList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case hourlyCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath)
            cell.backgroundColor = .cyan
            return cell
        case dailyCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath)
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = .black
            }else {
                cell.backgroundColor = .darkGray
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        switch collectionView {
        case hourlyCollectionView:
            return CGSize(width: 75, height: height)
        case dailyCollectionView:
            return CGSize(width: 130, height: height)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case hourlyCollectionView:
            return 2
        case dailyCollectionView:
            return 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
