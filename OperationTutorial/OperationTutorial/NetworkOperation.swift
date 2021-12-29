//
//  NetoworkOperation.swift
//  OperationTutorial
//
//  Created by Developer on 20/12/21.
//

import Foundation
import UIKit
import MBProgressHUD

typealias RequestCompletionBlock = (_ data: Data?, _ error: Error?) -> Void

class NetworkOperation: Operation, URLSessionDataDelegate {
    
    var webUrl: URL?
    var receivedData: Data?
    let queue = OperationQueue()
    var requestCompletionBlock: RequestCompletionBlock?
    var soapMessage: String = ""
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true // session waits for suitable connectivity rather than failing immediately.
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    private var _executing = false {
        willSet{
            willChangeValue(forKey: "isExecuting")
        }
        didSet{
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet{
            willChangeValue(forKey: "isFinished")
        }
        didSet{
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override  var isFinished: Bool{
        return _finished
    }
    
    func executing(_ executing: Bool){
        _executing = executing
    }
    
    func finish(_ finished: Bool){
        _finished = finished
    }
    
    init(url: URL, requestData: String, requestCompletionBlock: @escaping RequestCompletionBlock) { // along with url pass the data response as well.
        super.init()
        self.webUrl = url
        self.requestCompletionBlock = requestCompletionBlock
        soapMessage = requestData
        queue.addOperation(self)
        
    }
    
    override public func start() {
        if isCancelled {
            finish(true)
            return
        }
        executing(true)
        main()
    }
    
    func finish() {
        
        self.willChangeValue(forKey: "isExecuting")
        self.willChangeValue(forKey: "isFinished")
        
        if isExecuting {
            executing(false)
        }
        if !isFinished {
            finish(true)
        }
        
        self.didChangeValue(forKey: "isExecuting")
        self.didChangeValue(forKey: "isFinished")
        
        if queue.operationCount == 0 {
            
        }
        
    }
    
    override func main(){
        guard isCancelled == false else {
            self.finish()
            return
        }
        
        self.executing(true)
        self.loadURL()
        
    }
    
    func loadURL(){
        let url = webUrl
        let request = NSMutableURLRequest(url: url!)
        request.setValue("application/soap+xml", forHTTPHeaderField: "Content-Type")
        request.setValue("\(soapMessage.count)", forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = soapMessage.data(using: .utf8)
        defer {
            session.finishTasksAndInvalidate()
        }
        let dataTask: URLSessionDataTask? = session.dataTask(with: request as URLRequest)
        dataTask?.resume()
    }
    
    override func cancel() {
        super.cancel()
    }
}

extension NetworkOperation: URLSessionTaskDelegate{
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode)
                
        else {
            completionHandler(.cancel)
            DispatchQueue.main.async { [weak self] in
                self?.finish()
            }
            DispatchQueue.main.async {
                self.finish()
            }
            return
        }
        if response.statusCode != 200 {
            print("error")
        }
        if !isCancelled {
            receivedData = Data()
            completionHandler(.allow)
        }
        else {
            completionHandler(.cancel)
            DispatchQueue.main.async { [weak self] in
                self?.finish()
            }
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if !isCancelled {
            self.receivedData?.append(data) // it takes each data instanes received by the task and appends it to a buffer called received data.
        }
        else {
            DispatchQueue.main.async {
                self.finish()
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        //self.loadButton.isEnabled = true
        if let error = error {
            print(error)
            
        } // checck for error and convert the receivedData buffer to a string and see it as the content of the web View.
        if !isCancelled {
            if let receivedData = self.receivedData //The data to use as the contents of the webpage.
            {
                self.requestCompletionBlock?(self.receivedData, nil)
                print(receivedData)
                
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.finish()
        }
        
    }
}
