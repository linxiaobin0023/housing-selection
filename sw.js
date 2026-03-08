// 嘉禧苑选房系统 Service Worker
const CACHE_NAME = 'housing-selection-v1';
const urlsToCache = [
  '/选房系统/',
  '/选房系统/index.html',
  '/选房系统/houses_data.json',
  '/选房系统/manifest.json',
  '/选房系统/icons/icon-192x192.png',
  '/选房系统/icons/icon-512x512.png'
];

// 安装时缓存资源
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('缓存已打开');
        return cache.addAll(urlsToCache);
      })
      .catch(err => {
        console.log('缓存失败:', err);
      })
  );
  self.skipWaiting();
});

// 激活时清理旧缓存
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            console.log('删除旧缓存:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
  self.clients.claim();
});

// 拦截请求，优先使用缓存
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // 缓存命中，返回缓存
        if (response) {
          return response;
        }
        // 缓存未命中，发起网络请求
        return fetch(event.request)
          .then(response => {
            // 检查响应是否有效
            if (!response || response.status !== 200 || response.type !== 'basic') {
              return response;
            }
            // 克隆响应（因为响应流只能使用一次）
            const responseToCache = response.clone();
            caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache);
              });
            return response;
          })
          .catch(() => {
            // 网络请求失败，尝试返回离线页面
            if (event.request.mode === 'navigate') {
              return caches.match('/选房系统/index.html');
            }
          });
      })
  );
});

// 后台同步（用于离线操作后同步）
self.addEventListener('sync', event => {
  if (event.tag === 'sync-housing-data') {
    event.waitUntil(syncHousingData());
  }
});

async function syncHousingData() {
  // 同步房源数据的逻辑
  console.log('同步房源数据...');
}

// 推送通知支持
self.addEventListener('push', event => {
  const options = {
    body: event.data.text(),
    icon: '/选房系统/icons/icon-192x192.png',
    badge: '/选房系统/icons/icon-72x72.png',
    vibrate: [100, 50, 100],
    data: {
      url: '/选房系统/'
    }
  };
  event.waitUntil(
    self.registration.showNotification('嘉禧苑选房系统', options)
  );
});

// 点击通知
self.addEventListener('notificationclick', event => {
  event.notification.close();
  event.waitUntil(
    clients.openWindow(event.notification.data.url)
  );
});
