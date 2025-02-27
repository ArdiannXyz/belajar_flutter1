self.importScripts('sqlite3.js');
self.sqlite3InitModule().then(function (sqlite3) {
  self.sqlite3 = sqlite3;
});
