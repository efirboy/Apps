//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Alexandr Garkalin on 29.05.2025.
//

import Foundation

// Сервис для получения погодных данных с использованием WeatherAPI

final class WeatherService {
    
    //MARK: - Свойства
    private let apiKey = APIKeys.weatherApiKey
    private let baseUrl = "https://api.weatherapi.com/v1/forecast.json"
    
    // MARK: - Методы
    
    // Получение прогноза погоды на указанное количество дней для заданного города
    func fetchWeather(for city: String, days: Int = 5, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        
        // Кодируем название города, чтобы оно корректно использовалось в URL
        guard let urlEncodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Формируем строку запроса с параметрами
        let urlString = "\(baseUrl)?q=\(urlEncodedCity)&days=\(days)&key=\(apiKey)&lang=ru"
        
        // Проверяем, что строка запроса корректно преобразуется в URL-объект
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Выполняем сетевой запрос к WeatherAPI
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            // Обработка ошибки сети
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Проверяем, что получены данные
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                // Пытаемся декодировать полученные данные в модель WeatherResponse
                let decoder = JSONDecoder()
                let response = try decoder.decode(WeatherResponse.self, from: data)
                // Возвращаем результат через замыкание
                completion(.success(response))
            } catch {
                // Обработка ошибки декодирования
                completion(.failure(error))
            }
        }
        // Запускаем задачу
        task.resume()
    }
}

// Возможные сетевые ошибки
enum NetworkError: Error {
    case invalidURL // Некорректный URL
    case noData // Нет данных в ответе
}

