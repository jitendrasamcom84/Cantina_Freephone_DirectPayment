import UIKit

class QATableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAns: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(questionAnswer : QuestionAnswer , index : Int) {
        lblQuestion.text =  questionAnswer.question!;
        lblAns.text = questionAnswer.answer;
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
