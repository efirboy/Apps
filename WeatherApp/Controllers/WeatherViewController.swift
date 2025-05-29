//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Alexandr Garkalin on 29.05.2025.
//

import UIKit
import AVKit
import AVFoundation

final class WeatherViewController: UIViewController {
    
    //MARK: - Свойства
    private let tableView = UITableView()
    private let viewModel = WeatherViewModel()
    private let city = "Казань"
    
    // констрейнты
    private var tableViewTopConstraint: NSLayoutConstraint!
    private var cityLabelTopConstraint: NSLayoutConstraint!
    
    // для воспроизведения видео
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let videoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    // Лейблы для текущей погоды
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textColor = .white
        label.shadowColor = UIColor.black.withAlphaComponent(0.8)
        label.shadowOffset = CGSize(width: 3, height: 3)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 104, weight: .thin)
        label.textColor = .white
        label.shadowColor = UIColor.black.withAlphaComponent(0.8)
        label.shadowOffset = CGSize(width: 3, height: 3)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.shadowColor = UIColor.black.withAlphaComponent(0.8)
        label.shadowOffset = CGSize(width: 3, height: 3)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        configureAudioSession()
        setupVideoContainerView()
        setupTableView()
        bindViewModel()
        viewModel.loadWeather(for: city)
    }
    
    
    //MARK: - Методы
    
    // возобновление видео
    @objc private func appDidBecomeActive() {
        player?.play()
    }

    // Очистка наблюдателя
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Фон (видео)
    private func setupVideoContainerView() {
        view.addSubview(videoContainerView)
        NSLayoutConstraint.activate([
            videoContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            videoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        // Лейблы поверх видео
        videoContainerView.addSubview(cityLabel)
        videoContainerView.addSubview(temperatureLabel)
        videoContainerView.addSubview(conditionLabel)
        
        setupLabelsConstraints()
    }
    
    // Констрейнты для лейблов
    private func setupLabelsConstraints() {
        cityLabelTopConstraint = cityLabel.topAnchor.constraint(equalTo: videoContainerView.topAnchor, constant: 100)

        NSLayoutConstraint.activate([
            cityLabelTopConstraint,
            cityLabel.centerXAnchor.constraint(equalTo: videoContainerView.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
            temperatureLabel.centerXAnchor.constraint(equalTo: videoContainerView.centerXAnchor),
            
            conditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 8),
            conditionLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            conditionLabel.trailingAnchor.constraint(equalTo: cityLabel.trailingAnchor)
        ])
    }
    
    // Конфигурация аудиосессии
    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            // Тихая сессия (чтобы звук из видео не перехватывал звук устройства)
            try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("Не удалось настроить аудиосессию: \(error)")
        }
    }
    
    // Запуск видео
    private func playVideo(named videoName: String) {
        guard let path = Bundle.main.path(forResource: videoName, ofType:"mp4") else {
            print("Видео \(videoName).mp4 не найдено")
            return
        }
        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        player?.isMuted = true
        playerLayer?.removeFromSuperlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoContainerView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = playerLayer {
            videoContainerView.layer.insertSublayer(playerLayer, at: 0)
        }
        
        // Зацикливание видео
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: .zero)
            self?.player?.play()
        }
        player?.play()
    }
    
    // Выбор фона в зависимости от погодных условий (с использованием WeatherCondition enum)
    private func updateBackground(for condition: String) {
        let weatherCondition = WeatherCondition.from(description: condition)
        playVideo(named: weatherCondition.videoName)
    }

    // Таблица
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.alwaysBounceVertical = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
        tableView.tableFooterView = UIView()
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        // UIPanGestureRecognizer для таблицы
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleTablePan(_:)))
        pan.delegate = self
        tableView.addGestureRecognizer(pan)

        // Констрейты
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 2)

        NSLayoutConstraint.activate([
            tableViewTopConstraint,
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // Обработка свайпа вниз по таблице
    @objc private func handleTablePan(_ pan: UIPanGestureRecognizer) {
        let translationY = pan.translation(in: view).y
        
        let tableMaxTop = view.bounds.height / 2
        let cityMaxTop: CGFloat = 100
        
        // Тянем вниз
        if translationY > 0, tableViewTopConstraint.constant < tableMaxTop {
            let delta = min(translationY, tableMaxTop - tableViewTopConstraint.constant)
            tableViewTopConstraint.constant += delta
            cityLabelTopConstraint.constant = min(cityMaxTop, cityLabelTopConstraint.constant + delta)
            
            pan.setTranslation(.zero, in: view)
            view.layoutIfNeeded()
        }
    }

    // Обработка обновления данных и ошибок от ViewModel
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
            
            // Сегодняшняя погода (первый день) и обновление фона
            if let today = self?.viewModel.forecastDays.first {
                self?.updateBackground(for: today.day.condition.text)
                self?.cityLabel.text = self?.city
                self?.temperatureLabel.text = "\(Int(today.day.avgtemp_c))°"
                self?.conditionLabel.text = today.day.condition.text
            }
        }
        
        // Алерт, если пришла ошибка из модели
        viewModel.onError = { [weak self] errorMessage in
            let alert = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forecastDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }

        let day = viewModel.forecastDays[indexPath.row]
        cell.configure(with: day)
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - UITableViewDelegate & UIScrollViewDelegate

extension WeatherViewController: UITableViewDelegate, UIScrollViewDelegate {
    // Настройка поведения элементов при прокрутке
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        let tableMinTop: CGFloat = 320
        let tableMaxTop: CGFloat = view.bounds.height / 2
        
        let cityMinTop: CGFloat = 75
        let cityMaxTop: CGFloat = 100
        
        if offsetY > 0, tableViewTopConstraint.constant > tableMinTop {
            let delta = min(offsetY, tableViewTopConstraint.constant - tableMinTop)
            tableViewTopConstraint.constant -= delta
            
            // Сдвигаем cityLabel вверх, но не меньше cityMinTop
            cityLabelTopConstraint.constant = max(cityMinTop, cityLabelTopConstraint.constant - delta)
            
            // Корректируем contentOffset, чтобы избежать двойной прокрутки
            scrollView.contentOffset.y -= delta
            
            // Применяем изменения layout с анимацией
            UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

//MARK: - UIGestureRecognizerDelegate

extension WeatherViewController: UIGestureRecognizerDelegate {
    
    // Одновременно и UIPan, и стандартный скролл
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
