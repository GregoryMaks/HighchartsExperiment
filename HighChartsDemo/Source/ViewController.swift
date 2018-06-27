//
//  ViewController.swift
//  HighChartsDemo
//
//  Created by Gregory Maksyuk on 6/26/18.
//  Copyright © 2018 Gregory M. All rights reserved.
//

import UIKit
import Highcharts


class ViewController: UIViewController {

    let pxPerMinute = 300.0
    let pxPerSecond = 300.0 / 60.0
    
    var chartView: HIChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView = HIChartView(frame: view.bounds)
        
        let options = HIOptions()
        
        let plotArea = HIScrollablePlotArea()
        plotArea.minWidth = 1000
        plotArea.scrollPositionX = 0
        
        let axis = HIXAxis()
        axis.min = 0
        axis.minRange = 1000
        options.xAxis = [axis]
        
        let chart = HIChart()
        chart.type = "line"
        chart.animation = true
        chart.scrollablePlotArea = plotArea
        options.chart = chart
        
        let boost = HIBoost()
        boost.seriesThreshold = 1
        boost.allowForce = true
        options.boost = boost
        
        let title = HITitle()
        title.text = "Demo chart"
        options.title = title
        
        let series = HILine()
//
//        var newData = [Double]()
//        for _ in 0..<15000 {
//            newData.append(Double(arc4random() % 200))
//        }
//        plotArea.minWidth = NSNumber(value: 768.0 * 3.0)
        
        series.data = []
        options.series = [series]
        
        chartView.options = options
        
        view.addSubview(chartView)

        
        var secondsElapsed = 0.0
        
        func appendData() {
            var newData = [Double]()
            for _ in 0..<10 {
                newData.append(Double(arc4random() % 200))
            }

            var oldData = series.data
            oldData?.append(contentsOf: newData)
            series.data = oldData

            // Update parameters
            secondsElapsed += 1.0
            plotArea.minWidth = NSNumber(value: pxPerSecond * secondsElapsed)

//            chartView.updateOptions()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                appendData()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            appendData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


/*
 - (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    self.chartView = [[HIChartView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 20, self.view.bounds.size.width, 300.0f)];
 
    HIOptions *options = [[HIOptions alloc]init];
 
    HIChart *chart = [[HIChart alloc]init];
    chart.type = @"column";
    options.chart = chart;
 
    HITitle *title = [[HITitle alloc]init];
    title.text = @"Demo chart";
    options.title = title;
 
    HIColumn *series = [[HIColumn alloc]init];
    series.data = @[@49.9, @71.5, @106.4, @129.2, @144, @176, @135.6, @148.5, @216.4, @194.1, @95.6, @54.4];
    options.series = @[series];
    self.chartView.options = options;
 
    [self.view addSubview:self.chartView];
}*/
