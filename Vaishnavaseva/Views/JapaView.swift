import UIKit

@IBDesignable class JapaView: UIView
  {
  //Colors
  @IBInspectable var color1: UIColor = UIColor(red: (250.0/255.0), green: (196.0/255), blue: (45.0/255.0), alpha: 1.0)
    {
    willSet
      {
      progressView1.progressTintColor = newValue
      }
    }
  
  @IBInspectable var color2: UIColor = UIColor(red: (241.0/255.0), green: (139.0/255), blue: (36.0/255.0), alpha: 1.0)
    {
    willSet
      {
      progressView1.trackTintColor = newValue
      }
    }
  
  @IBInspectable var color3: UIColor = UIColor(red: (208.0/255.0), green: (41.0/255), blue: (122.0/255.0), alpha: 1.0)
    {
    willSet
      {
      progressView2.progressTintColor = newValue
      }
    }
  
  @IBInspectable var color4: UIColor = UIColor(red: (41.0/255.0), green: (102.0/255), blue: (205.0/255.0), alpha: 1.0)
    {
    willSet
      {
      progressView2.trackTintColor = newValue
      }
    }
  
  @IBInspectable var delimiterColor: UIColor = UIColor(red: (170.0/255.0), green: (170.0/255), blue: (170.0/255.0), alpha: 1.0)
    {
    willSet
      {
      delimiterView.backgroundColor = newValue
      }
    }
  
  @IBInspectable var borderColor: UIColor = UIColor.lightGrayColor()
    {
    willSet
      {
      view.layer.borderColor = newValue.CGColor
      }
    }
  
  @IBInspectable var borderWidth: CGFloat = 1
    {
      willSet
      {
      view.layer.borderWidth = newValue
      }
    }
  
  @IBInspectable var roundsTarget: Int = 16
    {
    didSet
      {
      recalculateLayout()
      }
    }
  
  //Rounds count by time of the day
  @IBInspectable var rounds0: Int = 4
    {
    didSet
      {
      recalculateLayout()
      }
    }
  @IBInspectable var rounds1: Int = 4
    {
    didSet
      {
      recalculateLayout()
      }
    }
  @IBInspectable var rounds2: Int = 4
    {
    didSet
      {
      recalculateLayout()
      }
    }
  @IBInspectable var rounds3: Int = 4
    {
    didSet
      {
      recalculateLayout()
      }
    }

  //Controls
  @IBOutlet var mainView: UIView!
  @IBOutlet weak var progressView1: UIProgressView!
  @IBOutlet weak var progressView2: UIProgressView!
  @IBOutlet weak var delimiterView: UIView!
  
  //Constraints
  @IBOutlet weak var progressView1LeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var progressView1TrailingConstraint: NSLayoutConstraint!
    {
    didSet
      {
      if progressView1TrailingConstraintOriginal == nil
        {
        progressView1TrailingConstraintOriginal = NSLayoutConstraint(item: progressView1TrailingConstraint.firstItem, attribute: progressView1TrailingConstraint.firstAttribute, relatedBy: progressView1TrailingConstraint.relation, toItem: progressView1TrailingConstraint.secondItem, attribute: progressView1TrailingConstraint.secondAttribute, multiplier: progressView1TrailingConstraint.multiplier, constant: progressView1TrailingConstraint.constant)
        }
      }
    }
  var progressView1TrailingConstraintOriginal: NSLayoutConstraint!//we are going to change the progressView1TrailingConstraint structure in some cases, which can cause problems when using the control in a table view cell
  @IBOutlet weak var progressView2LeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var progressView2TrailingConstraint: NSLayoutConstraint!
    {
    didSet
      {
      if progressView2TrailingConstraintOriginal == nil
        {
        progressView2TrailingConstraintOriginal = NSLayoutConstraint(item: progressView2TrailingConstraint.firstItem, attribute: progressView2TrailingConstraint.firstAttribute, relatedBy: progressView2TrailingConstraint.relation, toItem: progressView2TrailingConstraint.secondItem, attribute: progressView2TrailingConstraint.secondAttribute, multiplier: progressView2TrailingConstraint.multiplier, constant: progressView2TrailingConstraint.constant)
        }
      }
    }
  var progressView2TrailingConstraintOriginal: NSLayoutConstraint!//we are going to change the progressView2TrailingConstraint structure in some cases, which can cause problems when using the control in a table view cell
  @IBOutlet weak var delimiterViewLeadingCostraint: NSLayoutConstraint!
  
  func recalculateLayout()
    {
    //entire length of the control including the zone after delimiter is 1
    //delimiter is always on 0.8 position (16 rounds)
    //zone after the delimiter (more the 16 rounds) has different scale:
    //first half of it is first 16 rounds extra (32 total),
    //then we split next half on two parts and change scale again, so
    //0.75 of it means 32 rounds extra
    //0.875 of it means 48 rounds extra (64 total), etc.
    let delimiterPosition: Float    = 0.8
    
    var sumRounds = 0
    let roundsByDayTime = [rounds0, rounds1, rounds2, rounds3]
    var percentageTakenByRoundsProgressive: [Float] = [0.2, 0.4, 0.6, 0.8]//just for test purpose
    for (index, rounds) in roundsByDayTime.enumerate()
      {
      sumRounds += rounds
      if sumRounds <= roundsTarget
        {
        percentageTakenByRoundsProgressive[index] = delimiterPosition * Float(sumRounds) / Float(roundsTarget)
        }
      else
        {
        var addCount  = (sumRounds - roundsTarget) / roundsTarget
        let remainder = (sumRounds - roundsTarget) % roundsTarget
        if remainder == 0
          {
          --addCount
          }
        percentageTakenByRoundsProgressive[index] =
          delimiterPosition +
          (Float(1) - delimiterPosition) * sumOfHalfAdded(addCount) +
          (Float(1) - delimiterPosition) * sumOfHalfAdded(addCount + 1) * Float(remainder)/Float(roundsTarget)
        }
      }
    
    //Set the constraints
    let progressView1TrailingConstraintMultiplier: Float = percentageTakenByRoundsProgressive[1] * 2
    let progressView2TrailingConstraintMultiplier: Float = percentageTakenByRoundsProgressive[3] * 2
    let delimiterViewLeadingCostraintMultiplier: Float   = delimiterPosition * 2
    
    
    let newConsraint1 = progressView1TrailingConstraintMultiplier > 0 ?
      NSLayoutConstraint(item: progressView1TrailingConstraintOriginal.firstItem, attribute: progressView1TrailingConstraintOriginal.firstAttribute, relatedBy: progressView1TrailingConstraintOriginal.relation, toItem: progressView1TrailingConstraintOriginal.secondItem, attribute: progressView1TrailingConstraintOriginal.secondAttribute, multiplier: CGFloat(progressView1TrailingConstraintMultiplier), constant: progressView1TrailingConstraintOriginal.constant) :
      NSLayoutConstraint(item: progressView1TrailingConstraint.firstItem, attribute: progressView1TrailingConstraint.firstAttribute, relatedBy: progressView1LeadingConstraint.relation, toItem: progressView1LeadingConstraint.secondItem, attribute: progressView1LeadingConstraint.secondAttribute, multiplier: progressView1LeadingConstraint.multiplier, constant: progressView1LeadingConstraint.constant)
    
    let newConsraint2 = progressView2TrailingConstraintMultiplier > 0 ?
      NSLayoutConstraint(item: progressView2TrailingConstraintOriginal.firstItem, attribute: progressView2TrailingConstraintOriginal.firstAttribute, relatedBy: progressView2TrailingConstraintOriginal.relation, toItem: progressView2TrailingConstraintOriginal.secondItem, attribute: progressView2TrailingConstraintOriginal.secondAttribute, multiplier: CGFloat(progressView2TrailingConstraintMultiplier), constant: progressView2TrailingConstraintOriginal.constant) :
      NSLayoutConstraint(item: progressView2TrailingConstraint.firstItem, attribute: progressView2TrailingConstraint.firstAttribute, relatedBy: progressView2LeadingConstraint.relation, toItem: progressView2LeadingConstraint.secondItem, attribute: progressView2LeadingConstraint.secondAttribute, multiplier: progressView2LeadingConstraint.multiplier, constant: progressView2LeadingConstraint.constant)
      
    mainView.removeConstraint(progressView1TrailingConstraint);
    mainView.removeConstraint(progressView2TrailingConstraint);
    
    progressView1TrailingConstraint = newConsraint1
    mainView.addConstraint(progressView1TrailingConstraint);
    
    progressView2TrailingConstraint = newConsraint2
    mainView.addConstraint(progressView2TrailingConstraint);
    
    if CGFloat(delimiterViewLeadingCostraintMultiplier) != delimiterViewLeadingCostraint.multiplier
      {
      let newConsraint = NSLayoutConstraint(item: delimiterViewLeadingCostraint.firstItem, attribute: delimiterViewLeadingCostraint.firstAttribute, relatedBy: delimiterViewLeadingCostraint.relation, toItem: delimiterViewLeadingCostraint.secondItem, attribute: delimiterViewLeadingCostraint.secondAttribute, multiplier: CGFloat(delimiterViewLeadingCostraintMultiplier), constant: delimiterViewLeadingCostraint.constant)
      mainView.removeConstraint(delimiterViewLeadingCostraint);
      delimiterViewLeadingCostraint = newConsraint
      mainView.addConstraint(delimiterViewLeadingCostraint);
      }
    
    //Set the percentage of the progress views
    if percentageTakenByRoundsProgressive[1] > 0
      {
      progressView1.progress = percentageTakenByRoundsProgressive[0] / percentageTakenByRoundsProgressive[1]
      }
    if percentageTakenByRoundsProgressive[3] - percentageTakenByRoundsProgressive[1] > 0
      {
      progressView2.progress = (percentageTakenByRoundsProgressive[2] - percentageTakenByRoundsProgressive[1]) / (percentageTakenByRoundsProgressive[3] - percentageTakenByRoundsProgressive[1])
      }
      
    //TODO: find out why progressView2 is visible even if it's width is 0
    //This is a hack to hide progress views if their width is 0
    progressView1.hidden = rounds0 == 0 && rounds1 == 0
    progressView2.hidden = rounds2 == 0 && rounds3 == 0
    }
  
  func sumOfHalfAdded(times: Int) -> Float
    {
    return Float(1) - Float(1)/pow(Float(2), Float(times))
    }

  override init(frame: CGRect)
    {
    // 1. setup any properties here

    // 2. call super.init(frame:)
    super.init(frame: frame)

    // 3. Setup view from .xib file
    xibSetup()
    }

  required init?(coder aDecoder: NSCoder)
    {
    // 1. setup any properties here

    // 2. call super.init(coder:)
    super.init(coder: aDecoder)

    // 3. Setup view from .xib file
    xibSetup()
    }

  var view: UIView!

  func xibSetup()
    {
    view = loadViewFromNib()

    // use bounds not frame or it'll be offset
    view.frame = bounds

    // Make the view stretch with containing view
    view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

    // Adding custom subview on top of our view (over any custom drawing > see note below)
    addSubview(view)
    }

  func loadViewFromNib() -> UIView
    {
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib = UINib(nibName: "JapaView", bundle: bundle)

    // Assumes UIView is top level and only object in JapaView.xib file
    let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
      
    view.layer.borderColor = borderColor.CGColor
    view.layer.borderWidth = borderWidth
  
    return view
    }



    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

  }
