# 🚀 Exotic

Exotic is a scalable, production-grade Flutter application built using Clean Architecture, Bloc state management, and a structured Git workflow for safe collaboration.

This project follows professional engineering standards to ensure maintainability, scalability, and stability.

---

# 📂 Project Structure

```
lib/
 ├── core/
 │     ├── network/
 │     ├── constants/
 │     ├── error/
 │     └── utils/
 │
 ├── data/
 │     ├── models/
 │     ├── repositories/
 │     └── services/
 │
 ├── domain/
 │     ├── entities/
 │     ├── repositories/
 │     └── usecases/
 │
 ├── presentation/
 │     ├── bloc/
 │     ├── pages/
 │     └── widgets/
```

This separation ensures:

- Clear responsibility boundaries
- Testable business logic
- Maintainable UI structure

---

# 🌳 Git Branching Strategy

We follow a simplified production-ready branching model.

## 🔹 Permanent Public Branches

### `main`

- Production-ready code
- Always stable
- Protected branch
- Updated only via merge from `develop`

### `develop`

- Integration branch
- All completed features merge here first
- Used for staging/testing

---

## 🌿 Temporary Public Branches

Created from `develop` and deleted after merging.

### Feature Branches

```
feature/<feature-name>
```

Examples:

```
feature/homepage-ui
feature/cart-module
feature/isar-cache
feature/auth-module
```

### Bugfix Branches

```
bugfix/<issue-name>
```

### Hotfix Branches

```
hotfix/<production-issue>
```

---

## 🔒 Private (Local Only) Branches

Used for experimentation and not pushed to GitHub.

Examples:

```
experiment/bloc-refactor
temp/ui-testing
test/new-idea
```

A branch is private simply because it is not pushed.

---

# 🔁 Development Workflow

## 1️⃣ Start a Feature

```
git checkout develop
git pull
git checkout -b feature/feature-name
```

---

## 2️⃣ Work & Commit

```
git add .
git commit -m "feat: add homepage banner logic"
git push -u origin feature/feature-name
```

---

## 3️⃣ Merge Feature into Develop

```
git checkout develop
git pull
git merge feature/feature-name
git push
```

Delete branch:

```
git branch -d feature/feature-name
git push origin --delete feature/feature-name
```

---

## 4️⃣ Release to Production

When develop is stable:

```
git checkout main
git merge develop
git push
```

---

# 📝 Commit Message Convention

We follow conventional commit style:

```
feat: add new homepage layout
fix: resolve banner parsing crash
refactor: restructure element model
docs: update README
test: add bloc unit tests
```

Types:

- feat → New feature
- fix → Bug fix
- refactor → Code improvement
- docs → Documentation
- test → Testing
- chore → Maintenance

---

# 🔄 Pull Request Guidelines

Before creating a PR:

- Ensure branch is updated with latest `develop`
- Ensure no debug prints
- Run `flutter analyze`
- Run tests
- Provide clear PR description

PR Title Format:

```
[Feature] Add homepage UI
[Bugfix] Fix cart total calculation
```

---

# 🧪 Testing Policy

Production-grade means tested code.

Minimum requirements:

- Unit tests for repositories
- Bloc tests for state management
- Widget tests for critical UI

Run tests using:

```
flutter test
```

---

# 🛡 Code Quality Standards

- No direct commits to `main`
- No unfinished code merged to `develop`
- No print statements in production
- Avoid dynamic types
- Prefer const constructors
- Follow Dart lint rules

Run:

```
flutter analyze
```

---

# 📦 Versioning (Semantic Versioning)

We follow:

```
MAJOR.MINOR.PATCH
```

Example:

- 1.0.0 → Initial stable release
- 1.1.0 → New feature added
- 1.1.1 → Bug fix

---

# ⚠ Collaboration Rules

- Always pull before starting work
- Always branch from `develop`
- Never push directly to `main`
- Delete feature branches after merge
- Keep commits small and meaningful

---

# 🚀 Future Improvements(Optional)

- CI/CD integration (GitHub Actions)
- Automated testing pipeline
- Code coverage enforcement
- Release tagging automation

---

# 📄 License

Add your license here.
