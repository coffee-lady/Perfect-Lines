// 1. Put here the name of your game:
const cachePrefix = "sudoku-master";

// 2. Increment the version every time you publish your game!
const cacheName = cachePrefix + "-v1";

const cacheList = [
    "https://yandex.ru/games/sdk/v2",
    "images/icon.svg",
    "images/logo.svg",
    "scripts/loading.js",
    "scripts/sessionsHelper.js",
    "scripts/wrapper.js",
    "styles/css/loadingScreen.css",
    "styles/css/style.css",
    "styles/fonts/RobotoBold.ttf",
    "index.html",
    "dmloader.js",
    "sw.js",
    "dmengine.wasm",
    "dmengine_wasm.js",
    "dmengine_asmjs.js",
    "archive/archive_files.json",
    "archive/game.arcd0",
    "archive/game.arci0",
    "archive/game.dmanifest0",
    "archive/game.projectc0",
    "archive/game.public.der0",
    "https://yandex.ru/games/sdk/v2"
];

// Installation of the service worker
self.addEventListener("install", function(event) {
    event.waitUntil(
        caches.open(cacheName).then((cache) => {
            return cache.addAll(cacheList);
        }).catch((err) => console.log(err))
    );
});

// Deletion of old cache
self.addEventListener("activate", function(event) {
    console.assert(typeof cacheName === "string");
    console.assert(typeof cachePrefix === "string");

    event.waitUntil(
        caches.keys().then((keyList) => {
            return Promise.all(
                keyList.map((key) => {
                    if (key.indexOf(cachePrefix) === 0 && key !== cacheName) {
                        return caches.delete(key);
                    }
                })
            );
        }).catch((err) => console.log(err))
    );
});

// Handling of data stored in the device cache with exceptions
self.addEventListener("fetch", function(event) {
    if (
        event.request.method !== "GET" ||
        event.request.url.indexOf("http://") === 0 ||
        event.request.url.indexOf("an.yandex.ru") !== -1
    ) {
        return;
    }

    event.respondWith(
        caches.match(event.request, { ignoreSearch: true }).then(function(response) {
            return response || fetch(event.request);
        }).catch((err) => console.log(err))
    );
});
