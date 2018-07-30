//
//  FolderViewController.swift
//  FileExplorer
//

import UIKit

class FolderViewController: UITableViewController {
	var directory = URL(fileURLWithPath: "/") {
		didSet {
			self.reload()
		}
	}
	var contents = [URL]()
	
	override func viewDidLoad() {
		self.reload()
	}
	
	func reload() {
		do {
			self.contents = try FS.contents(of: self.directory)
			self.tableView?.reloadData()
		} catch let e {
			let alert = UIAlertController(title: "Failed to get contents", message: e.localizedDescription, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		self.title = self.directory.path
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "FolderSegue" {
			let row = self.tableView.indexPathForSelectedRow!.row
			let url = self.contents[row]
			(segue.destination as! FolderViewController).directory = url
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.contents.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let url = self.contents[indexPath.row]
		
		let cellID: String
		if FS.isFolder(url) {
			cellID = "FolderCell"
		} else {
			cellID = "FileCell"
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		cell.textLabel?.text = url.lastPathComponent
		
		if FS.isFolder(url) {
			cell.imageView?.image = #imageLiteral(resourceName: "Folder")
			cell.accessoryType = .disclosureIndicator
		} else {
			cell.imageView?.image = #imageLiteral(resourceName: "NotFound")
			cell.accessoryType = .none
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
