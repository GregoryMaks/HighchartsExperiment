//
//  ViewController.swift
//  HighChartsDemo
//
//  Created by Gregory Maksyuk on 6/26/18.
//  Copyright © 2018 Gregory M. All rights reserved.
//

import UIKit
import Highcharts
import WebKit


class ViewController: UIViewController {

    let pxPerMinute = 300.0
    let pxPerSecond = 300.0 / 60.0
    
    var chartView: HIChartView!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView = HIChartView(frame: view.bounds)
        
        let options = HIOptions()
        
        let plotArea = HIScrollablePlotArea()
        plotArea.minWidth = 1000
        plotArea.scrollPositionX = 0
        
        let xAxis = HIXAxis()
        xAxis.min = 0
        xAxis.minRange = 1000
        options.xAxis = [xAxis]
        
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
        
        series.data = []
        options.series = [series]
        
        chartView.options = options
        
        view.addSubview(chartView)

        beginAppendingDataUsingWrapper(series: series, plotArea: plotArea)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.inspectWebView()
//        }
//        beginAppendingDataDirectlyWithJS(series: series, plotArea: plotArea)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func beginAppendingDataUsingWrapper(series: HILine, plotArea: HIScrollablePlotArea) {
        
        var secondsElapsed = 0.0
        
        func appendData() {
            var newData = [Double]()
            for _ in 0..<600 {
                newData.append(Double(arc4random() % 200))
            }
            
            var oldData = series.data
            oldData?.append(contentsOf: newData)
            series.data = oldData
            
            // Update parameters
            secondsElapsed += 1.0
            plotArea.minWidth = NSNumber(value: pxPerSecond * 60 * secondsElapsed)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { appendData() }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { appendData() }
    }
    
    func inspectWebView() {
        for subview in chartView.subviews where subview is WKWebView {
            self.webView = subview as! WKWebView
            break
        }
        
        let js = "document.documentElement.outerHTML.toString()"
        webView.evaluateJavaScript(js) { (result, error) in
            if let result = result {
                print("WebView RESULT: \(result)")
            } else {
                print("WebView ERROR: \(String(describing: error))")
            }
        }
        
    }
    
    func beginAppendingDataDirectlyWithJS(series: HILine, plotArea: HIScrollablePlotArea) {
        
        // Append data
        let appendJS = """
var series = chart.series[0];
setInterval(function () {
    for (i = 0; i < 10; i++) {
          var animation = {
            duration: 800,
            easing: 'easeOutBounce'
        }
        series.addPoint(Math.round(Math.random() * 100), false, false, animation);
    }
    chart.redraw()

}, 1000);
"""
        webView.evaluateJavaScript(appendJS) { (result, error) in
            if let result = result {
                print("Append OK")
            } else {
                print("Append ERROR: \(String(describing: error))")
            }
        }
        
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
