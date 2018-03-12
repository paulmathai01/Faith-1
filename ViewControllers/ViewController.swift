//
//  ViewController.swift
//  Faith
//
//  Created by Akshat Agarwal on 10/03/18.
//  Copyright © 2018 Akshat. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
import SwiftSiriWaveformView
import ApiAI
import MapKit




var spokenText : String = "Hello, I am Faith. I am here to help."
var mySpokenText: String = ""


class ViewController: UIViewController, SFSpeechRecognizerDelegate, CLLocationManagerDelegate  {
    
    
    var list : [String] = [""]
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    @IBOutlet weak var collectionTable: UICollectionView!
    
    var change:CGFloat = 0.01
    var timer:Timer?
    var timer2:Timer?
    
    var flag = 0
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var microphoneImage: UIButton!
    @IBOutlet weak var waveformOutlet: SwiftSiriWaveformView!
    var locationManager : CLLocationManager!
    // for text to speech
    let speechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidAppear(_ animated: Bool) {
        speakfunc(self)
        self.locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startUpdatingLocation()
        collectionTable.setGradientBackground(colorOne: r1, colorTwo: r2)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionTable.alpha = 0
        print(latitude)
        settings()
        
    }
    
    func settings() {
        usernameLabel.text = "Hey \(username)"
        DataHandler.shared.persistData { (stat) in
            if stat {
                RequestHandler.shared.getQuotes(completion: { (stat1) in
                    if stat {
                        RequestHandler.shared.getPlaces(completion: { (stat2) in
                            if stat2 {
                                
                                RequestHandler.shared.getMusic(completion: { (stat3) in
                                    if stat3 {
                                        
                                        
                                        RequestHandler.shared.getRestaurants(completion: { (stat4) in
                                            if stat4 {
                                                self.collectionTable.reloadData()
                                                self.setUp()
                                            }
                                        })
                                    }
                                    
                                })
                            }
                        })
                    }
                })
                
            }
        }
    }
    
    func setUp() {
        DispatchQueue.main.async {
            self.microphoneButton.isEnabled = false
            self.speechRecognizer?.delegate = self
            
            SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
                
                var isButtonEnabled = false
                
                switch authStatus {
                case .authorized:
                    isButtonEnabled = true
                case .denied:
                    isButtonEnabled = false
                    
                case .restricted:
                    isButtonEnabled = false
                    
                case .notDetermined:
                    isButtonEnabled = false
                }
                OperationQueue.main.addOperation() {
                    self.microphoneButton.isEnabled = isButtonEnabled
                }
            }
        }
    }
    
    @IBAction func speakfunc(_: AnyObject) {
        happyOrSadView()
        speaker()
    }
    
    
    override func viewDidLayoutSubviews() {
        self.collectionTable.layer.cornerRadius = 21
    }
    
    func speaker() {
        let speechUtterance = AVSpeechUtterance(string: spokenText)
        speechUtterance.rate = 0.45
        speechUtterance.pitchMultiplier = 1.0
        speechUtterance.volume = 100
        speechSynthesizer.speak(speechUtterance)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func microphoneTapped(_ sender: AnyObject)
    {
        timer?.invalidate()
        print(spokenText)
//        self.waveformOutlet.density = 0

        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                try audioSession.setMode(AVAudioSessionModeDefault)
                
            } catch {
                print("audioSession properties weren't set because of an error.")
            }
            happyOrSadView()
            sendMessage()
            microphoneButton.isEnabled = false
            
            
        } else {
            startRecording()
            self.waveformOutlet.density = 2.0
            timer2 = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(ViewController.refreshAudioView(_:)), userInfo: nil, repeats: true)
        }
        
        
    }
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textLabel.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            //
            mySpokenText = self.textLabel.text!
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textLabel.text = "Say something, I'm listening!"
        
    }
    
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    func happyOrSadView(){
        
        if mySpokenText.contains("happy") || mySpokenText.contains("joyful") || mySpokenText.contains("merry") || mySpokenText.contains("funny") || mySpokenText.contains("angry")
        {
            UIView.animate(withDuration: 1, animations: {
                self.view.backgroundColor = UIColor.white
                self.usernameLabel.textColor = UIColor.black
                self.questionLabel.textColor = UIColor.black
                self.textLabel.textColor = UIColor.black
                self.logoImage.image = #imageLiteral(resourceName: "Group 2")
                self.microphoneImage .setImage(#imageLiteral(resourceName: "MicrophoneHappy"), for: .normal)
                self.waveformOutlet.backgroundColor = UIColor.clear
                
                
                
            }, completion: nil)
            
            
            
        }
        else if mySpokenText.contains("sad") || mySpokenText.contains("depressed") || mySpokenText.contains("low") || mySpokenText.contains("unhappy") || mySpokenText.contains("crying")
        {
            UIView.animate(withDuration: 1, animations: {
                self.view.backgroundColor = UIColor.black
                self.usernameLabel.textColor = UIColor.white
                self.questionLabel.textColor = UIColor.white
                self.textLabel.textColor = UIColor.white
                self.logoImage.image = #imageLiteral(resourceName: "logo")
                self.microphoneImage .setImage(#imageLiteral(resourceName: "MicrophoneSad"), for: .normal)
                self.waveformOutlet.backgroundColor = UIColor.clear
            }, completion:  nil)
            
            
        }
        
        collectionTable.alpha = 1
    }
    
    
    @objc func sendMessage() {
        spokenText = questionLabel.text!
        let request = ApiAI.shared().textRequest()
        
        request?.query = mySpokenText
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if (response.result.fulfillment.speech) != nil {
                
                spokenText = response.result.fulfillment.speech
                self.usernameLabel.text = spokenText
                self.questionLabel.text = ""

                func speak(_ phrases: [(phrase: String, wait: Double)]){
                    if let (phrase, wait) = phrases.first{
                        let speechUtterance = AVSpeechUtterance(string: spokenText)
                        speechUtterance.rate = 0.45
                        speechUtterance.pitchMultiplier = 1.0
                        speechUtterance.volume = 100
                        self.speechSynthesizer.speak(speechUtterance)
                        let rest = Array(phrases.dropFirst())
                        if !rest.isEmpty {
                            self.delay(wait) {
                                self.speaker()
                            }
                        }
                        print ("success xx")
                    }
                }
                
                
            }
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
        
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()){
        
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func locationManager(manager: CLLocationManager!,   didUpdateLocations locations: [AnyObject]!) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        latitude = locValue.latitude
        longitude = locValue.longitude
        print("coordinates")
        print(latitude)
        print(longitude)
    }
    
    @objc internal func refreshAudioView(_:Timer) {
        if self.waveformOutlet.amplitude <= self.waveformOutlet.idleAmplitude || self.waveformOutlet.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.waveformOutlet.amplitude += self.change
    }
    
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return music.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.setGradientBackground(colorOne: r1, colorTwo: r2)
        cell.songArtist.text = music[indexPath.row].mydata[indexPath.row].artist!
        cell.songTitle.text = music[indexPath.row].mydata[indexPath.row].title!
        
        cell.cView.setGradientBackground(colorOne: r1, colorTwo: r2)
        
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = music[indexPath.row].mydata[indexPath.row].preview!
        play(url : url)
    }
    
    func play(url: String) {
        print("playing \(url)")
        
        let url = URL(string: url)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        player!.play()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
  
        return UIEdgeInsetsMake(0, 5, 0, 5)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-10, height: collectionView.frame.height-10)
    }
    
}


