//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Alexandr Garkalin on 29.05.2025.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    static let identifier = "WeatherTableViewCell"
    
    private let iconImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let tempLabel = UILabel()
    private let windLabel = UILabel()
    private let humidityLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        layoutSubviewsCustom()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        iconImageView.contentMode = .scaleAspectFit
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        tempLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        windLabel.font = .systemFont(ofSize: 14)
        humidityLabel.font = .systemFont(ofSize: 14)
        dateLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(windLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(dateLabel)
    }
    
    private func layoutSubviewsCustom() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        windLabel.translatesAutoresizingMaskIntoConstraints = false
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 48),
            iconImageView.heightAnchor.constraint(equalToConstant: 48),
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            
            tempLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            tempLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            
            windLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 4),
            windLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            
            humidityLabel.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 4),
            humidityLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            humidityLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with forecastDay: ForecastDay) {
        dateLabel.text = forecastDay.date
        descriptionLabel.text = forecastDay.day.condition.text
        tempLabel.text = "Темп: \(forecastDay.day.avgtemp_c) °C"
        windLabel.text = "Ветер: \(forecastDay.day.maxwind_kph) км/ч"
        humidityLabel.text = "Влажность: \(forecastDay.day.avghumidity)%"
        
        let iconUrlString = "https:\(forecastDay.day.condition.icon)"
        if let url = URL(string: iconUrlString) {
            downloadImage(from: url)
        } else {
            iconImageView.image = nil
        }
    }
    
    private func downloadImage(from url: URL) {
        // Простейшая загрузка без кеширования для примера
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.iconImageView.image = image
            }
        }.resume()
    }
}

