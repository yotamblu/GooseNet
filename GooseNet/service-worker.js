self.addEventListener("install", () => {
    self.skipWaiting();
});

self.addEventListener("activate", () => {
    self.clients.claim();
});

// Online-first: no caching yet (safe)
self.addEventListener("fetch", () => { });
