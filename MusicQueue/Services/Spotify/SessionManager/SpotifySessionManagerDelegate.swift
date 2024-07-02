/**
 This extension adds conformance to the SPTSessionManagerDelegate protocol for the SpotifySessionManager class.
 */

extension SpotifySessionManager: SPTSessionManagerDelegate {
    
    /**
     This method is called when a session is successfully initiated.
     
     - Parameters:
        - manager: The session manager responsible for initiating the session.
        - session: The initiated session.
     */
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("success", session)
        KeychainHelper.standard.save(Data(session.accessToken.utf8), service: "com.poles.carpoolapp", account: "spotifyToken")
        authenticated?(true)
    }
    
    /**
     This method is called when a session fails to be established.
     
     - Parameters:
        - manager: The session manager responsible for establishing the session.
        - error: The error that occurred during the establishment of the session.
     */
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("Failed to establish session with error \(error)")
        authenticated?(false)
    }
    
    /**
     This method is called when a session is successfully renewed.
     
     - Parameters:
        - manager: The session manager responsible for renewing the session.
        - session: The renewed session.
     */
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
    }
    
    /**
     This method handles opening URLs in the application.
     
     - Parameters:
         - app: The application object that received the URL request.
         - url: The URL resource to open.
         - options: A dictionary of options for handling the URL request. Default value is an empty dictionary.
     */
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Void {
        print("Handling the URL open")
        print("URL", url)
        sessionManager.application(app, open: url, options: options)
    }
}
