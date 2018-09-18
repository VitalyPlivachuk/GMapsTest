//
//  VPFiltersViewController.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/18/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit

class VPFiltersViewController: UIViewController {
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var minDurationStepper: UIStepper!
    @IBOutlet weak var minDurationLabel: UILabel!
    @IBOutlet weak var maxDurationStepper: UIStepper!
    @IBOutlet weak var maxDurationLabel: UILabel!
    @IBOutlet weak var pullView: UIView!
    
    weak var dataSource: VPFiltersViewControllerDataSource?
    weak var delegate: VPFiltersViewControllerDelegate?
    
    private var types: [String?] = []
    private var colors: [UIColor] = []
    private var observers: [NSObjectProtocol] = []
    
    private let colorsCollectionViewCellReuseIdentifier = "colors"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpActions()
        setUpCollectionView()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    func update(_: Any? = nil){
        var types : [String?]? = dataSource?.filtersViewControllerTypes()
        types?.append(nil)
        self.types = types ?? [nil]
        
        self.typeSegmentControl.removeAllSegments()
        types?.enumerated().forEach{self.typeSegmentControl.insertSegment(withTitle: $1?.capitalized ?? "None", at: $0, animated: false)}
        self.typeSegmentControl.selectedSegmentIndex = types!.count
        
        self.colors = dataSource?.filtersViewControllerColors() ?? []
        
        updateLabels()
        colorsCollectionView.reloadData()
    }
    
    func updateLabels(){
        maxDurationLabel.text = "Max duration: \(Int(maxDurationStepper.value))"
        minDurationLabel.text = "Min duration: \(Int(minDurationStepper.value))"
        
        maxDurationStepper.minimumValue = minDurationStepper.value
        minDurationStepper.maximumValue = maxDurationStepper.value
    }
    
    func setUpUI(){
        pullView.layer.cornerRadius = pullView.frame.height / 2
        pullView.backgroundColor = .gray
    }
    
    func setUpActions(){
        
        self.observers = [
            NotificationCenter.default.addObserver(forName: .modelUpdated,
                                                   object: nil,
                                                   queue: .main,
                                                   using: update)
        ]
        
        maxDurationStepper.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .valueChanged)
        minDurationStepper.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .valueChanged)
        typeSegmentControl.addTarget(self, action: #selector(segmentControlValueChanged(sender:)), for: .valueChanged)
    }
    
    func setUpCollectionView(){
        self.colorsCollectionView.dataSource = self
        self.colorsCollectionView.delegate = self
        self.colorsCollectionView.register(UINib(nibName: "VPColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: colorsCollectionViewCellReuseIdentifier)
        self.colorsCollectionView.allowsMultipleSelection = true
    }
    
    @objc func stepperValueChanged(sender:UIStepper){
        if sender === maxDurationStepper{
            delegate?.filtersViewController(newMaxDuration: Int(sender.value))
        } else if sender === minDurationStepper {
            delegate?.filtersViewController(newMinDuration: Int(sender.value))
        }
        updateLabels()
    }
    
    @objc func segmentControlValueChanged(sender:UISegmentedControl){
        delegate?.filtersViewController(newType: types[sender.selectedSegmentIndex])
    }
    
    fileprivate func selected(colors:[UIColor]){
        delegate?.filtersViewController(newColors: colors)
    }
    
    deinit {
        observers.forEach{NotificationCenter.default.removeObserver($0)}
        observers = []
    }
    
}

extension VPFiltersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorsCollectionViewCellReuseIdentifier, for: indexPath) as! VPColorCollectionViewCell
        cell.color = colors[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellAction(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        cellAction(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.bounds.height
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    fileprivate func cellAction(_ collectionView: UICollectionView) {
        let indexes:[Int] = collectionView.indexPathsForSelectedItems?.map{$0.row} ?? []
        let selectedColors = indexes.map{colors[$0]}
        selected(colors: selectedColors)
    }
}


protocol VPFiltersViewControllerDelegate: class {
    func filtersViewController(newMinDuration:Int)
    func filtersViewController(newMaxDuration:Int)
    func filtersViewController(newColors:[UIColor])
    func filtersViewController(newType:String?)
}

protocol VPFiltersViewControllerDataSource: class {
    func filtersViewControllerTypes() -> ([String])
    func filtersViewControllerColors() -> ([UIColor])
}
