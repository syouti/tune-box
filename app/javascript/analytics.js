// Google Analytics カスタムイベント管理
class Analytics {
  // ページビューイベント
  static trackPageView(pageName) {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'page_view', {
        page_title: pageName,
        page_location: window.location.href
      });
    }
  }

  // アルバム追加イベント
  static trackAlbumAdd(albumName) {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'album_add', {
        event_category: 'engagement',
        event_label: albumName,
        value: 1
      });
    }
  }

  // スクリーンショット撮影イベント
  static trackScreenshot() {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'screenshot_taken', {
        event_category: 'engagement',
        event_label: 'canvas_screenshot'
      });
    }
  }

  // シェアイベント
  static trackShare(platform) {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'share', {
        method: platform,
        event_category: 'engagement'
      });
    }
  }

  // 検索イベント
  static trackSearch(query) {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'search', {
        search_term: query,
        event_category: 'engagement'
      });
    }
  }

  // ユーザー登録イベント
  static trackSignUp(method) {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'sign_up', {
        method: method,
        event_category: 'engagement'
      });
    }
  }

  // ログインイベント
  static trackLogin(method) {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'login', {
        method: method,
        event_category: 'engagement'
      });
    }
  }
}

// グローバルに公開
window.Analytics = Analytics;
