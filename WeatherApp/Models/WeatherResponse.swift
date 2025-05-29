//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Alexandr Garkalin on 29.05.2025.
//

// MARK: - Модели данных

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let forecast: Forecast
}

struct Location: Codable {
    let name: String
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let day: Day
}

struct Day: Codable {
    let avgtemp_c: Double
    let maxwind_kph: Double
    let avghumidity: Double
    let condition: Condition
}

struct Condition: Codable {
    let text: String
    let icon: String
}


