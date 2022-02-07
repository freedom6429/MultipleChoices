//
//  ViewController.swift
//  MultipleChoices
//
//  Created by Wen Luo on 2022/1/19.
//

import UIKit

class ViewController: UIViewController {

    //建立好題庫陣列、題序index、分數、計時器、倒數計數器counter
    var questions = Question.data
    var index = 0
    var score = 0
    var timer = Timer()
    var counter = 1000
    
    //問題題目label
    @IBOutlet weak var questionLabel: UILabel!
    
    //分數label
    @IBOutlet weak var scoreLabel: UILabel!
    
    //包含顯示問題、題數、倒數bar、選項按鈕、下一題按鈕的view
    @IBOutlet weak var contentView: UIView!
    
    //倒數bar
    @IBOutlet weak var counterProgressBar: UIProgressView!
    
    //題號label
    @IBOutlet weak var questionNumberLabel: UILabel!
    
    //選項buttons拉成outlet collections
    @IBOutlet var choiceButtons: [UIButton]!
    
    //作答完的訊息label
    @IBOutlet weak var messageLabel: UILabel!
    
    //下一題button
    @IBOutlet weak var nextButton: UIButton!
    
    //開始測驗button
    @IBOutlet weak var newGameButton: UIButton!
    
    //再玩一次button
    @IBOutlet weak var playAgainButton: UIButton!
    
    //顯示題目和選擇的函式
    func showQuestion(_ index: Int) {
        //取出問題
        let question = questions[index]
        //取出選擇後分割為array
        let choicesSubstring = question.choices.split(separator: ",")
        //因為分割後型別為Substring要再分別轉為String才可用
        var choices = [String]()
        for choice in choicesSubstring {
            choices.append(String(choice))
        }
        //將選擇隨機排列一次
        choices.shuffle()
        //設定選擇button的title
        questionLabel.text = question.question
        for i in 0...3 {
            choiceButtons[i].setTitle(choices[i], for: .normal)
        }
        //更新最上面的題號label
        questionNumberLabel.text = "第\(index + 1)/10題"
    }
    
    func showAnswer(_ index: Int) {
        //查詢目前題目的答案
        let answer = questions[index].answer
        //找到答案的button加上紅色粗外框，並且所有選項button都不能按
        for choiceButton in choiceButtons {
            if choiceButton.title(for: .normal) == answer {
                choiceButton.configuration?.background.strokeWidth = 3
                choiceButton.configuration?.background.strokeColor = UIColor.red
            }
            choiceButton.isUserInteractionEnabled = false
        }
    }
    
    
    //測驗初始化
    func initialGame() {
        index = 0
        score = 0
        questions.shuffle()
        scoreLabel.text = score.description
        messageLabel.text = ""
        nextButton.isHidden = true
        contentView.isUserInteractionEnabled = true
        for choiceButton in choiceButtons {
            choiceButton.isUserInteractionEnabled = true
        }
        messageLabel.text = ""
        //選項button外觀恢復未選的樣式
        for choiceButton in choiceButtons {
            choiceButton.configuration?.background.strokeWidth = 0.5
            choiceButton.configuration?.background.strokeColor = UIColor.darkGray
        }
        
    }
    
    //計時器每0.01秒固定執行的函式
    @objc func updateTime() {
        counter -= 1
        //progress bar的progress單位切分到小數點後3位才能做出連續性的變化
        counterProgressBar.progress = Float(counter) / 1000
        //如果counter倒數到0計時器就停止計時，並顯示正確答案
        if counter == 0 {
            timer.invalidate()
            showAnswer(index)
            messageLabel.isHidden = false
            if index != 9 {
                messageLabel.text = "超過作答時間"
                nextButton.isHidden = false
            } else {
                messageLabel.text = "答題結束，恭喜您得了\(score)分！"
                contentView.isUserInteractionEnabled = false
                playAgainButton.isHidden = false
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func chooseButton(_ sender: UIButton) {
        //被選到的button會改變strokeWidth和strokeColor
        sender.configuration?.background.strokeWidth = 3
        sender.configuration?.background.strokeColor = UIColor.tintColor
        //所有選項在進到新一題前都disable
        for choiceButton in choiceButtons {
            choiceButton.isUserInteractionEnabled = false
        }
        //停止計時
        timer.invalidate()
        let answer = questions[index].answer
        //debug用
        //print(sender.title(for: .normal)!)
        //print(answer)
        if sender.title(for: .normal) == answer {
            score += questions[index].point
            scoreLabel.text = score.description
            messageLabel.text = "恭喜答對！"
            messageLabel.isHidden = false
        } else {
            showAnswer(index)
            messageLabel.text = "可惜沒有答對.."
            messageLabel.isHidden = false
        }
        if index == 9 {
            messageLabel.text = "答題結束，恭喜您得了\(score)分！"
            contentView.isUserInteractionEnabled = false
            playAgainButton.isHidden = false
        } else {
            nextButton.isHidden = false
        }
    }
    
    
    @IBAction func nextQuestionButton(_ sender: UIButton) {
        //題序+1，顯示下一題
        sender.isHidden = true
        index += 1
        showQuestion(index)
        //所有選項button恢復可以互動
        for choiceButton in choiceButtons {
            choiceButton.isUserInteractionEnabled = true
        }
        //選項button外觀恢復未選的樣式
        for choiceButton in choiceButtons {
            choiceButton.configuration?.background.strokeWidth = 0.5
            choiceButton.configuration?.background.strokeColor = UIColor.darkGray
        }
        //清空上面message內容
        messageLabel.text = ""
        //重新計時
        counter = 1000
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func playButton(_ sender: UIButton) {
        //隱藏本身、顯示題目區塊
        sender.isHidden = true
        contentView.isHidden = false
        //重置遊戲然後顯示第一題
        initialGame()
        showQuestion(index)
        //重新開始計時
        counter = 1000
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        print(choiceButtons[0].isUserInteractionEnabled)
    }
    

}

