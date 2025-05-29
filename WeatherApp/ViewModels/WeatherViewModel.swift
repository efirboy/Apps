//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Alexandr Garkalin on 29.05.2025.
//

import Foundation

final class WeatherViewModel {
    
    //MARK: - Свойства
    private let weatherService = WeatherService()
    private(set) var forecastDays: [ForecastDay] = []
    
    //MARK: - Замыкания
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    
    // MARK: - Методы
    
    // Загрузка прогноза погоды для указанного города
    func loadWeather(for city: String) {
        weatherService.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.forecastDays = response.forecast.forecastday
                    self?.onUpdate?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}

