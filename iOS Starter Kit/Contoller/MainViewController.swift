//
//  SecondViewController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 12/14/17.
//  Copyright © 2017 Sodep. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import SideMenu
//URL de la API que se va a consultar.
let GITHUBAPI = "https://api.github.com/repos/googlesamples/android-architecture/issues"

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var number: UILabel!
}
var data = [Item]()
class MainViewController: UIViewController, UITableViewDataSource,
                            UITableViewDelegate {
    var currentSelectedCell: Int?
    var refresher: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var noItemView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        //Agrega gesto para actualizar el tableView haciendo un swipe down
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.getTableData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        tableView.tableFooterView = UIView()
        getTableData()
        setSideMenu()
        //Check si el dispositivo soporta 3D touch
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    func setSideMenu() {
        //swiftlint:disable line_length
        SideMenuManager.default.menuLeftNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.defaultManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: .left)
        SideMenuManager.default.menuFadeStatusBar = false
        //swiftlint:enable line_length
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ItemTableViewCell
        cell?.title!.text = data[indexPath.row].title
        cell?.number!.text = data[indexPath.row].number
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0 {
            tableView.backgroundView = noItemView
        } else {
            tableView.backgroundView = nil
        }
        return data.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedCell = indexPath.row
        performSegue(withIdentifier: "showBodySegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BodyViewController {
            // swiftlint:disable:next line_length
            let text = data[currentSelectedCell!].body == "" ? "No hay descripción para este issue" : data[currentSelectedCell!].body
            let titleText = data[currentSelectedCell!].title == "" ? "Sin titutlo" : data[currentSelectedCell!].title
            destination.bodyText = text
            destination.issueTitle = titleText
        }
    }
    //Función que hace el Get Request
    @objc func getTableData() {
        Alamofire.request(GITHUBAPI).responseJSON { (response) in
            if response.result.isSuccess {
                //En dataJSON se almacena el JSON resultante del request
                let dataJSON: JSON = JSON(response.result.value!)
                self.updateTableData(json: dataJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    func updateTableData(json: JSON) {
        data.removeAll()
//      Ejemplo de JSON
//       {
//          "data1":"some data"
//          "data2":"some data"
//          "data3": {
//              "data31": "Dato que quiero extraer"
//              "data32": "some data"
//           }
//        }
// Para extrar por ejemplo el string de "data31" se hace json[2][1].stringValue,
// donde json es donde se guardó el resutado del request
        if let numberOfElements = (json.array?.count), numberOfElements != 0 {
            for i in 0...numberOfElements - 1 {
                let cellData = Item()
                cellData.title = json[i]["title"].stringValue
                cellData.body = json[i]["body"].stringValue
                cellData.number = ("#"+json[i]["number"].stringValue)
                data.append(cellData)
            }
        }
        refresher.endRefreshing()
        tableView.reloadData()
    }
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {}
}

extension MainViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        //Obtener el indice de la celda que se está presionando
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) as? ItemTableViewCell else {return nil}
        //instanciar el VC que se quiere mostrar como preview
        guard let bodyVC = storyboard?.instantiateViewController(withIdentifier: "issueDetailVC") as?
            BodyViewController else {return nil}
        bodyVC.issueTitle = cell.title.text!
        //swiftlint:disable:next line_length
        bodyVC.bodyText = data[indexPath.row].body == "" ? "No hay descripción para este issue" : data[indexPath.row].body
        previewingContext.sourceRect = cell.frame
        return bodyVC
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        self.show(viewControllerToCommit, sender: self)
    }
}
