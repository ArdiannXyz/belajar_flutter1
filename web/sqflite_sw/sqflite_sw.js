var sqliteWorker;
importScripts('../sqlite3/sqlite3.js');

self.importScripts('sql-wasm.js');
self.sqlite3InitModule().then(function (sqlite3) {
  self.sqlite3 = sqlite3;
});
