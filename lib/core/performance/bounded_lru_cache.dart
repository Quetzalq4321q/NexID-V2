import 'dart:collection';

class _CacheEntry<V> {
  _CacheEntry({required this.value, required this.expiresAt});

  final V value;
  final DateTime expiresAt;

  bool isExpired(DateTime now) => now.isAfter(expiresAt);
}

/// Cache local acotada en memoria con politica LRU, expiracion por TTL y
/// deduplicacion de solicitudes en vuelo segun PRIORIDAD 0 (Seccion 2 y 5).
class BoundedLruCache<K, V> {
  BoundedLruCache({
    required int maxEntries,
    this.ttl = const Duration(minutes: 10),
  }) : _maxEntries = maxEntries < 1 ? 1 : maxEntries;

  int _maxEntries;
  final Duration ttl;
  final LinkedHashMap<K, _CacheEntry<V>> _store =
      LinkedHashMap<K, _CacheEntry<V>>();
  final Map<K, Future<V>> _inFlight = <K, Future<V>>{};

  int get length => _store.length;
  int get maxEntries => _maxEntries;
  int get inFlightCount => _inFlight.length;

  void updateMaxEntries(int newMax) {
    _maxEntries = newMax < 1 ? 1 : newMax;
    _evictOverflow();
  }

  V? get(K key) {
    final _CacheEntry<V>? entry = _store.remove(key);
    if (entry == null) return null;
    if (entry.isExpired(DateTime.now())) {
      return null;
    }
    _store[key] = entry;
    return entry.value;
  }

  void put(K key, V value) {
    _store.remove(key);
    _store[key] = _CacheEntry<V>(
      value: value,
      expiresAt: DateTime.now().add(ttl),
    );
    _evictOverflow();
  }

  /// Evita solicitudes duplicadas simultaneas para la misma clave.
  Future<V> putIfAbsentAsync(K key, Future<V> Function() loader) async {
    final V? cached = get(key);
    if (cached != null) return cached;

    final Future<V>? activeFuture = _inFlight[key];
    if (activeFuture != null) {
      return activeFuture;
    }

    final Future<V> created = loader();
    _inFlight[key] = created;
    try {
      final V result = await created;
      put(key, result);
      return result;
    } finally {
      _inFlight.remove(key);
    }
  }

  void remove(K key) {
    _store.remove(key);
  }

  void purgeExpired() {
    final DateTime now = DateTime.now();
    _store.removeWhere((_, _CacheEntry<V> entry) => entry.isExpired(now));
  }

  void clear() {
    _store.clear();
  }

  void _evictOverflow() {
    while (_store.length > _maxEntries) {
      _store.remove(_store.keys.first);
    }
  }
}
