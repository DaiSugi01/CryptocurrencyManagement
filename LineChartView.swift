//
//  LineChartView.swift
//  
//
//  Created by 杉原大貴 on 2021/01/21.
//

import UIKit
import Charts

class LineChartView: UIView {

    let lineChart: LineChartView = {
        let lc = LineChartView()
        lc.translatesAutoresizingMaskIntoConstraints = false
        return lc
    }()
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    let unitsSold = [10.0, 4.0, 6.0, 3.0, 12.0]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(lineChart)
        lineChart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        lineChart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40).isActive = true
        lineChart.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        lineChart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true
        setLineGraph()
    }

    func setLineGraph(){
        var entry = [ChartDataEntry]()
        
        for (i,d) in unitsSold.enumerated(){
            entry.append(ChartDataEntry(x: Double(i),y: d))
        }
        
        let dataset = LineChartDataSet(entries: entry, label: "Units Sold")
                
        lineChart.data = LineChartData(dataSet: dataset)
        lineChart.chartDescription?.text = "Item Sold Chart"
    }

}
