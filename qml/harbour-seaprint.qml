import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import Nemo.Notifications 1.0
import "pages"

ApplicationWindow
{
    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Item {
        id: db
        property var db_conn

        Component.onCompleted: {
            db_conn = LocalStorage.openDatabaseSync("TintDB", "1.0", "Tint storage", 100000)
            db_conn.transaction(function (tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS Favourites (url STRING UNIQUE)');

            });
        }

        function addFavourite(url) {
            db_conn.transaction(function (tx) {
                tx.executeSql('REPLACE INTO Favourites VALUES(?)', [url] );
            });
        }

        function getFavourites() {
            var favs = [];
            db_conn.transaction(function (tx) {
                var res = tx.executeSql('SELECT * FROM Favourites');
                if (res.rows.length !== 0) {
                    console.log(res.rows.item(0).url)
                    favs.push(res.rows.item(0).url);
                }
            });
            return favs
        }
    }

    Notification {
        id: notifier

        expireTimeout: 4000

        function notify(data) {
            console.log("notifyMessage", data)
            body = data
            previewBody = data
            publish()
        }
    }
}

