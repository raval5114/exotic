# Homepage Caching Architecture (Flutter)

## 📌 Objective
Design a scalable, server-friendly caching mechanism for homepage data to:

- Avoid repeated API calls
- Prevent rate limiting
- Improve performance
- Keep UI fast and responsive
- Ensure data consistency

This architecture uses a **version-based snapshot caching strategy**.

---

# 🏗 High-Level Architecture

```
UI (Bloc)
   ↓
Repository
   ↓
LocalDataSource (Cache)
   ↓
RemoteDataSource (API)
```

Caching logic lives inside the **Repository layer**.

---

# 🌐 APIs Involved

## 1️⃣ Tabs API
Endpoint: `/pages.php`

Used for:
- Fetching all homepage tabs
- Determining homepage version via `timestamp`

Important field:
```
"timestamp": 1772571772
```

This acts as the **homepage version identifier**.

---

## 2️⃣ Page Content API
Endpoint: `/page.php?slug={slug}`

Used for:
- Fetching content per tab

Important field:
```
"timestamp": 1771616535
```

---

# 🧠 Core Strategy: Snapshot + Version Comparison

We store a **single aggregated homepage snapshot** locally.

## Homepage Snapshot Structure

```dart
class HomepageCache {
  final String version;       // tabs API timestamp
  final Map<String, dynamic> data; // aggregated homepage snapshot
  final DateTime cachedAt;
}
```

- `version` = Tabs API timestamp
- `data` = Full homepage data (tabs + content)
- Single atomic storage

---

# 🔄 Data Fetch Flow

## On Homepage Load

### Step 1: Fetch Tabs API

```dart
final tabsResponse = await remote.getTabs();
final remoteVersion = tabsResponse.timestamp.toString();
```

### Step 2: Compare With Cache

```dart
final cached = await local.getHomepage();

if (cached != null && cached.version == remoteVersion) {
    return cached.data;
}
```

If versions match:
- Return cached snapshot
- Do NOT call page APIs

---

### Step 3: If Version Changed

- Fetch all tab slugs in parallel
- Aggregate responses
- Save snapshot
- Return fresh data

```dart
final results = await Future.wait([
   fetchPage(slug1),
   fetchPage(slug2),
   fetchPage(slug3),
]);
```

---

# 💾 Storage Strategy

## Recommended: Hive (JSON Blob Storage)

- Store under single key: `homepage_cache`
- Serialize entire snapshot as JSON
- No complex schema required
- Easy overwrite
- Lightweight

Example:

```dart
await box.put("homepage_cache", jsonEncode(snapshot));
```

---

# 🧱 Design Principles

## 1️⃣ Atomic Cache
Homepage cache is either:
- Fully valid
- Fully invalid

No partial updates.

---

## 2️⃣ Server-Driven Invalidation

Cache invalidation depends only on:

```
tabsResponse.timestamp
```

No time-based expiry required.

---

## 3️⃣ Single Source of Truth

Tabs API timestamp determines whether:
- Homepage changed
- Cache must refresh

---

# 🚀 Performance Optimizations

## Parallel API Calls
Use `Future.wait()` to fetch tab content simultaneously.

## Avoid Unnecessary Fetches
If version unchanged:
- Skip all content APIs

## Optional Background Refresh
- Return cache instantly
- Refresh in background
- Emit updated Bloc state if changed

---

# 🧪 Testing Strategy

## Unit Tests
- Version match → returns cache
- Version mismatch → fetches fresh data
- Null cache → fetches fresh data

## Integration Tests
- Simulate API version change
- Verify overwrite logic

---

# 🔮 Future Scalability

This design allows:

- Easy migration to Isar later
- Adding per-user cache keys
- Adding offline mode
- Introducing content hashing if backend supports it

Repository interface remains unchanged.

---

# 📂 Suggested Folder Structure

```
data/
 ├── datasources/
 │    ├── homepage_remote_datasource.dart
 │    ├── homepage_local_datasource.dart
 │
 ├── repositories/
 │    ├── homepage_repository.dart
```

---

# 🏁 Final Result

✅ Reduced server load  
✅ No rate limit issues  
✅ Instant homepage load  
✅ Clean architecture  
✅ Easy overwrite logic  
✅ Minimal storage  

---

# 📌 Summary

We use:

- Version-based invalidation
- Snapshot caching
- Single atomic storage
- Repository-controlled logic

This ensures a scalable and maintainable homepage caching system.