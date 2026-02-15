# Homepage Architecture (Option 1)

This document explains the finalized architecture used for the **dynamic Homepage** in this project. The design is intentionally scoped to a **single page (homepage)** while remaining clean, testable, and future‑ready.

The project follows **Option 1**, where the *Repository* is treated as a **contract/interface**, and a separate **DataStore** is responsible for caching and storage.

---

## 🎯 Goals of This Architecture

- Support a **dynamic CMS-driven homepage**
- Keep responsibilities **clearly separated**
- Avoid over‑engineering while staying scalable
- Respect the existing project convention where repositories act as **abstract contracts**

---

## 🧱 High-Level Architecture

```
Repository (abstract contract)
        ↓
Service (implements repository, HTTP + parsing)
        ↓
HomepageDataStore (cache / storage)
        ↓
HomepageBloc
        ↓
UI (Widgets)
```

---

## 🔹 Layer Responsibilities

### 1️⃣ Repository (Abstract Contract)

**Purpose:**
- Declare *what* operations are available
- Define method signatures only

**Key Rules:**
- No HTTP logic
- No caching
- No parsing

Think of it as:
> “These are the homepage-related operations my app supports.”

---

### 2️⃣ Service (Repository Implementation)

**Purpose:**
- Perform HTTP requests
- Handle API responses and errors
- Parse JSON into domain models
- Use `ElementFactory` to resolve dynamic elements

**Key Rules:**
- Stateless
- Always fetches fresh data
- Does NOT cache

The service is responsible only for **talking to the backend** and **returning parsed models**.

---

### 3️⃣ HomepageDataStore (Cache & Storage Layer)

**Purpose:**
- Store the parsed `HomepageModel`
- Decide whether to return cached data or fetch fresh data via Service

**Key Characteristics:**
- In-memory cache (for now)
- Homepage-specific
- No UI or Bloc dependency

**Why this layer exists:**
- Keeps Bloc clean
- Centralizes caching logic
- Allows future upgrades (TTL, Hive, offline support) without changing Bloc or UI

---

### 4️⃣ HomepageBloc

**Purpose:**
- Orchestrate homepage loading
- Emit loading / success / error states
- Handle refresh events

**Key Rules:**
- Never calls API directly
- Never parses JSON
- Never manages cache

Bloc only talks to **HomepageDataStore**.

---

### 5️⃣ UI (Widgets)

**Purpose:**
- Render homepage dynamically
- Iterate rows and elements
- Render widgets based on `element_type`

**Key Rules:**
- No API logic
- No parsing
- No caching

UI reacts purely to Bloc state.

---

## 🔁 Data Flow (Step-by-Step)

1. UI dispatches `LoadHomepage`
2. `HomepageBloc` calls `HomepageDataStore.getHomepage()`
3. `HomepageDataStore`:
   - Returns cached homepage if available
   - Otherwise calls `HomepageApiService`
4. Service fetches API data and parses it
5. Parsed `HomepageModel` is cached in DataStore
6. Bloc emits success state
7. UI renders the homepage

---

## 🧠 Why This Architecture Was Chosen

- Matches existing project usage of repositories as **contracts**
- Avoids renaming or refactoring existing layers
- Prevents mixing HTTP, cache, and UI state
- Easy to extend later for more pages

If new pages are added in the future:
- Add a new DataStore (e.g. `DealsDataStore`)
- Reuse the same Service and Repository pattern

---

## 🚫 What This Architecture Avoids

- ❌ Caching inside Bloc
- ❌ Storing data in Provider
- ❌ Parsing JSON in UI
- ❌ God classes with mixed responsibilities
- ❌ Premature CMS over‑generalization

---

## 📁 Suggested Naming Convention

- `HomepageRepository` → abstract contract
- `HomepageApiService` → implements repository
- `HomepageDataStore` → cache & storage
- `HomepageBloc` → state management
- `HomepageRenderer` → dynamic UI renderer

---

## ✅ Final Notes

This setup is intentionally **simple, explicit, and maintainable**. It supports the current requirement (homepage only) while leaving a clean path for future expansion — without forcing architectural rewrites.

This is a *pragmatic* architecture, not an academic one — and that’s exactly what this project needs.

