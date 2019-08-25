import QtQuick 2.0

Item {
    // actions
    signal clearCache()

    signal login(string username, string password)

    signal register(string username, string email, string password, string confirmPassword)

    signal logout()

    signal changePage(int page)

    signal getRequest(string url)
}
