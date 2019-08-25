import QtQuick 2.0
import Felgo 3.0

Item {

    // loading state
    readonly property bool busy: HttpNetworkActivityIndicator.enabled

    // configure request timeout
    property int maxRequestTimeout: 30000

    property string requestUrl: "http://10.10.253.39"

    // initialization
    Component.onCompleted: {
        // immediately activate loading indicator when a request is started
        HttpNetworkActivityIndicator.setActivationDelay(0)
    }

    // private
    QtObject {
        id: apiObject

        function login(data, success, error) {
            HttpRequest.post(requestUrl + "/login_check")
            .timeout(maxRequestTimeout)
            .set('Content-Type', 'application/json')
            .send(data)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }

        function register(data, success, error) {
            HttpRequest.post(requestUrl + "/register")
            .timeout(maxRequestTimeout)
            .set('Content-Type', 'application/json')
            .send(data)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }

        function get(url, token, success, error) {
            HttpRequest.get(requestUrl + url)
            .timeout(maxRequestTimeout)
            .set('Content-Type', 'application/json')
            .set('Authorization', 'Bearer ' + token)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }

        function post(url, data, token, success, error) {
            HttpRequest.post(requestUrl + url)
            .timeout(maxRequestTimeout)
            .set('Content-Type', 'application/json')
            .set('Authorization', 'Bearer ' + token)
            .send(data)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }

        function put(url, data, token, success, error) {
            HttpRequest.put(requestUrl + url)
            .timeout(maxRequestTimeout)
            .set('Content-Type', 'application/json')
            .set('Authorization', 'Bearer ' + token)
            .send(data)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }

        function postMedia(url, data, filePath, fileName, token, success, error) {
            HttpRequest.post(requestUrl + url)
            .timeout(maxRequestTimeout)
            .set('Authorization', 'Bearer ' + token)
            .field("owner", data)
            .attach(fileName, filePath)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }

        function getCoordinate(address, url, success, error) {
            address.replace(' ', '+')
            address.replace(',', "%2C")
            console.log(address)
            HttpRequest.get(url + address + "&key=0525fec96d97423da3bc8e6fbd7b67b4")
            .timeout(maxRequestTimeout)
            .set('Content-Type', 'application/json')
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }
    }

    // public rest api functions

    function login(data, success, error) {
        apiObject.login(data, success, error)
    }

    function registered(data, success, error) {
        apiObject.register(data, success, error)
    }

    function get(url, token, success, error) {
        apiObject.get(url, token, success, error)
    }

    function post(url, data, token, success, error) {
        apiObject.post(url, data, token, success, error)
    }

    function put(url, data, token, success, error) {
        apiObject.put(url, data, token, success, error)
    }

    function postMedia(url, data, filePath, fileName, token, success, error) {
        apiObject.postMedia(url, data, filePath, fileName, token, success, error)
    }

    function getCoordinate(address, success, error) {
        apiObject.getCoordinate(address, "https://api.opencagedata.com/geocode/v1/json?q=", success, error)
    }
}
