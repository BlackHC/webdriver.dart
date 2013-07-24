part of webdriver;

class Cookies {
  final String _sessionId;
  final CommandProcessor _commandProcessor;

  Options._(this._sessionId, this._commandProcessor);

  String get _prefix => '/session/$_sessionId/cookie';

  /**
   * Set a cookie.
   */
  Future add(Cookie cookie) =>
      _commandProcessor.post(_prefix, { 'cookie': cookie.json });

  /**
   * Delete the cookie with the given name.
   */
  Future delete(String name) =>
      _commandProcessor.delete('$_prefix/$name');

  /**
   * Delete all cookies visible to the current page.
   */
  Future deleteAll() => _commandProcessor.delete(_prefix);

  /**
   * Retrieve all cookies visible to the current page.
   */
  Future<List<Cookie>> get all =>
      _commandProcessor.get(_prefix)
      .then((cookies) => cookies.map((cookie) => new Cookie.fromJson(cookie)));
}

class Cookie {
  /**
   * The name of the cookie.
   */
  final String name;
  /**
   * The cookie value.
   */
  final String value;
  /**
   * (Optional) The cookie path.
   */
  final String path;
  /**
   * (Optional) The domain the cookie is visible to.
   */
  final String domain;
  /**
   * (Optional) Whether the cookie is a secure cookie.
   */
  final bool secure;
  /**
   * (Optional) When the cookie expires.
   */
  final DateTime expiry;

  const Cookie(this.name, this.value,
      {this.path, this.domain, this.secure, this.expiry});

  factory Cookie.fromJson(Map<String, dynamic> json) {
    var expiry;
    if (json['expiry'] is num) {
      expiry = new DateTime
          .fromMillisecondsSinceEpoch(json['expiry']*1000, isUtc: true);
    }
    return new Cookie(
        json['name'],
        json['value'],
        path: json['path'],
        domain: json['domain'],
        secure: json['secure'],
        expiry: expiry);
  }

  Map<String, dynamic> get json {
    var json = {
        'name': name,
        'value': value
    };
    if (path is String) {
      json['path'] = path;
    }
    if (domain is String) {
      json['domain'] = domain;
    }
    if (secure is bool) {
      json['secure'] = secure;
    }
    if (expiry is DateTime) {
      json['expiry'] = (expiry.millisecondsSinceEpoch / 1000).ceil();
    }
    return json;
  }
}

class Timeouts {
  final String _sessionId;
  final CommandProcessor _commandProcessor;

  Timeouts._(this._sessionId, this._commandProcessor);

  String get _prefix => '/session/$_sessionId/timeouts';

  Future _set(String type, Duration duration) =>
      _commandProcessor.post(_prefix,
          { 'type' : type, 'ms': duration.inMilliseconds});

  /**
   * Set the script timeout.
   */
  Future setScriptTimeout(Duration duration) => _set('script', duration);

  /**
   * Set the implicit timeout.
   */
  Future setImplicitTimeout(Duration duration) => _set('implicit', duration);

  /**
   * Set the page load timeout.
   */
  Future setPageLoadTimeout(Duration duration) => _set('page load', duration);

  /**
   * Set the async script timeout.
   */
  Future setAsyncScriptTimeout(Duration duration) =>
      _commandProcessor.post('$_prefix/async_script',
          { 'ms': duration.inMilliseconds});

  /**
   * Set the implicit wait timeout.
   */
  Future setImplicitWaitTimeout(Duration duration) =>
      _commandProcessor.post('$_prefix/implicit_wait',
          { 'ms': duration.inMilliseconds});
}