//
//  UserManager.swift
//  Blank Project
//
//  Created by framgia on 5/22/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

class UserManager {

    static var shared = UserManager()
    private var user: User?
    var isLogin: Bool {
        if let _ = user {
            return true
        } else {
            return false
        }
    }

    init() {
        reloadUserFromDB()
    }

    func reloadUserFromDB() {
        let path = pathForUserDataFile()
        if FileManager.default.fileExists(atPath: path) {
            user = (NSKeyedUnarchiver.unarchiveObject(withFile: path) as? User)
        }
    }

    func save() {
        if let user = user {
            let path = pathForUserDataFile()
            if !NSKeyedArchiver.archiveRootObject(user, toFile: path) {
                assertionFailure("Save user info failed")
            }
        }
    }

    func remove() {
        let path = pathForUserDataFile()
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {

            }
        }

    }

    private func pathForUserDataFile() -> String {

        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + "user_data.file"
        return documentsFolderPath
    }

    func getUser() -> User? {
        return user
    }

    func setUser(user: User?) {
        self.user = user
        save()
    }

    func logout() {
        api.logout()
        remove()
    }
    
}
