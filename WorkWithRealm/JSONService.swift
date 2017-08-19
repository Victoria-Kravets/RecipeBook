//
//  WorkWithJSON.swift
//  WorkWithRealm
//
//  Created by Viktoria on 8/11/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import PromiseKit

class JSONService {
    static func getJSONFromServer() -> Promise<String> {
        return Promise<String> { fulfill, _ in
            let url = "http://localhost:3000/users"
            let realm = try Realm()
            Alamofire.request(url)
                .responseArray { (response: DataResponse<[User]>) in
                    switch response.result {
                    case .success(let users):
                        do {
                            try realm.write {
                                for user in users {
                                    realm.add(user)
                                    fulfill("Successully filled realm")
                                }
                            }
                        } catch let error as NSError {
                            fatalError("\(error)")
                        }
                    case .failure(let error):
                        fatalError("\(error)")
                    }
            }
        }
    }

    @discardableResult static func deleteJSONFromServer(user: User) -> Promise<String> {
        return Promise<String> { fulfill, reject in
            let url = "http://localhost:3000/users/\(user.id)"
            let realm = try Realm()
            do {
                try realm.write {
                    let jsonUser = user.toJSON()
                    request(url, method: .delete,
                            parameters: jsonUser,
                            encoding: JSONEncoding.default,
                            headers: nil).validate()
                        .responseJSON { responseJSON in
                            switch responseJSON.result {
                            case .success:
                                _ = responseJSON.result.value
                                fulfill("Successully deleted")
                            case .failure(let error):
                                reject(error)
                        }
                    }
                }
            } catch let error {
                reject(error)
            }
        }
    }

    @discardableResult static func putJSONToServer(user: User) -> Promise<String> {

        return Promise<String> { fulfill, reject in
            let realm = try Realm()
            let url = "http://localhost:3000/users/\(user.id)"
            do {
                try realm.write {
                    let jsonUser = user.toJSON()
                    request(url, method: .put,
                            parameters: jsonUser,
                            encoding: JSONEncoding.default,
                            headers: nil).validate()
                        .responseJSON { responseJSON in

                        switch responseJSON.result {
                        case .success:
                            _ = responseJSON.result.value
                            fulfill("Successully edited")
                        case .failure(let error):
                            reject(error)
                        }
                    }

                }
            } catch let error {
                reject(error)
            }
        }
    }

    @discardableResult static func postJSONToServer(user: User) -> Promise<String> {
        return Promise<String> { fulfill, reject in
            let url = "http://localhost:3000/users"
            let realm = try Realm()
            do {
                try realm.write {
                    let jsonUser = user.toJSON()
                    request(url, method: .post,
                            parameters: jsonUser,
                            encoding: JSONEncoding.default,
                            headers: nil).validate()
                        .responseJSON { responseJSON in
                            switch responseJSON.result {
                            case .success:
                                _ = responseJSON.result.value
                                fulfill("Successully added")
                            case .failure(let error):
                                reject(error)
                            }
                    }
                }
            } catch let error {
                    reject(error)
            }
        }
    }
}
