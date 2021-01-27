//
//  CustomLineChartView.swift
//  Cryptocurrency Management
//
//  Created by 杉原大貴 on 2021/01/25.
//

import UIKit
import Charts

class CustomLineChartView: LineChartView {

    let lineChart: LineChartView = {
        let lc = LineChartView()
        lc.translatesAutoresizingMaskIntoConstraints = false
        lc.xAxis.granularity = 1
        lc.xAxis.drawLabelsEnabled = false
        lc.xAxis.drawGridLinesEnabled = false
        lc.xAxis.labelTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lc.xAxis.labelCount = 12
        lc.rightAxis.enabled = false
        lc.leftAxis.labelTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lc.noDataTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lc.animate(xAxisDuration: 1.2, yAxisDuration: 1.5, easingOption: .easeInOutElastic)
        lc.legend.enabled = false
        lc.doubleTapToZoomEnabled = false
        return lc
    }()

    override init(frame: CGRect){
        super.init(frame: frame)
        addChart()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addChart() {
        self.addSubview(lineChart)
        lineChart.xAxis.granularity = 1
        lineChart.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lineChart.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineChart.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        lineChart.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
    }
    
    func setLineGraph(values: [Double]){
        var entry = [ChartDataEntry]()
        
        for (i,d) in values.enumerated(){
            entry.append(ChartDataEntry(x: Double(i),y: d))
        }
        
        let dataset = LineChartDataSet(entries: entry, label: "Price")
        dataset.drawCirclesEnabled = false
        dataset.mode = .cubicBezier
        dataset.drawFilledEnabled = true
        dataset.drawValuesEnabled = false
        dataset.fillColor = #colorLiteral(red: 1, green: 0.8421531917, blue: 0.5401626297, alpha: 1)
        dataset.highlightColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        dataset.colors = [#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)]
        
        lineChart.data = LineChartData(dataSet: dataset)
        lineChart.chartDescription?.text = nil
    }
}
