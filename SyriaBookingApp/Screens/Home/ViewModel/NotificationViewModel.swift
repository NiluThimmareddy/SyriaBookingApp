//
//  NotificationViewModel.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 18/09/25.
//

import Foundation

final class NotificationViewModel {

    var BookingHistoryArray = [BookingHistoryModel]()
    var BookingListArray = [BookingDetailsModel]()
    var filteredHistoryArray = [BookingHistoryModel]()

    var onError: ((Error) -> Void)?
    var onSuccess: (([BookingHistoryModel]) -> Void)?

    private let apiClient: APIClient

    private var notificationTask: Task<Void, Never>?

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func fetchNotificationUsersList(includePast: Bool) {

        // Cancel previous request
        notificationTask?.cancel()

        // Get the user BEFORE starting the request
        guard let requestUser = UserSessionManager.getUser() else {
            clearNotificationData()
            return
        }

        let requestedUserID = requestUser.id

        print("🔵 Notification request user: \(requestedUserID)")

        notificationTask = Task { [weak self] in

            guard let self = self else { return }

            do {
             
                let response = try await self.apiClient.fetchUserNotificationsList(
                    includePast: includePast,
                    take: 50
                )

                // Check if this Task was cancelled
                try Task.checkCancellation()

                await MainActor.run {

                    // IMPORTANT:
                    // Check that the same user is still logged in
                    guard let currentUser = UserSessionManager.getUser(),
                          currentUser.id == requestedUserID else {
                        return
                    }

                    self.BookingHistoryArray = response.data
                    self.onSuccess?(response.data)
                }

            } catch is CancellationError {

                print("🟡 Notification request cancelled")

            } catch {

                guard !Task.isCancelled else { return }

                await MainActor.run {

                    // Don't show an error from an old user's request
                    guard let currentUser = UserSessionManager.getUser(),
                          currentUser.id == requestedUserID else {
                
                        return
                    }

                    self.onError?(error)
                }
            }
        }
    }

    func clearNotificationData() {

        notificationTask?.cancel()
        notificationTask = nil

        BookingHistoryArray.removeAll()
        BookingListArray.removeAll()
        filteredHistoryArray.removeAll()

        onSuccess = nil
        onError = nil
    }

    func fetchNotificationCount() async throws -> NotificationCountModel {

        let count = try await apiClient.send(
            endpoint: .fetchUserNotificationCount(),
            responseType: NotificationCountModel.self
        )
        return count
    }
}

extension Endpoint{
    static func fetchUserNotificationCount() -> Endpoint{
        Endpoint(
            path: APIURL.notificationCount.url,
            method: .get,
            authentication: .jwt
        )
    }

    static func fetchUserNotificationList(
        includePast: Bool = true,
        take: Int = 50
    ) -> Endpoint {

        var components = URLComponents(
            url: APIURL.notification.url,
            resolvingAgainstBaseURL: false
        )

        components?.queryItems = [
            URLQueryItem(
                name: "includePast",
                value: String(includePast)
            ),
            URLQueryItem(
                name: "take",
                value: String(take)
            )
        ]

        return Endpoint(
            path: components?.url ?? APIURL.notification.url,
            method: .get,
            authentication: .jwt
        )
    }
}


