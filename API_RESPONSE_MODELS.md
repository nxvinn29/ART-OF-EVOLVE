# API Response Models Documentation

This document describes the data models returned by the Art of Evolve API (simulated or real). It serves as a reference for frontend development and integration.

## Table of Contents
1. [User Profile](#1-user-profile)
2. [Habit](#2-habit)
3. [User Stats](#3-user-stats)
4. [Quote](#4-quote)

---

## 1. User Profile
Represents a registered user within the application.

### JSON Structure
```json
{
  "id": "string (UUID)",
  "email": "string",
  "displayName": "string",
  "photoUrl": "string (nullable)",
  "createdAt": "string (ISO 8601)",
  "lastLogin": "string (ISO 8601)",
  "preferences": {
    "theme": "light|dark|system",
    "notificationsEnabled": boolean
  }
}
```

### Fields
| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Unique identifier for the user. |
| `email` | String | User's email address. |
| `displayName` | String | User's public display name. |
| `preferences` | Object | User settings and configuration. |

---

## 2. Habit
Represents a habit that a user tracks.

### JSON Structure
```json
{
  "id": "string (UUID)",
  "userId": "string (UUID)",
  "title": "string",
  "description": "string (nullable)",
  "frequency": ["MO", "TU", "WE", "TH", "FR", "SA", "SU"],
  "reminderTime": "string (HH:mm)",
  "streak": integer,
  "completedDates": ["2026-01-01", "2026-01-02"],
  "isArchived": boolean
}
```

---

## 3. User Stats
Aggregated statistics for a user's progress.

### JSON Structure
```json
{
  "userId": "string (UUID)",
  "currentStreak": integer,
  "longestStreak": integer,
  "totalHabitsCompleted": integer,
  "level": integer,
  "xp": integer,
  "nextLevelXp": integer
}
```

---

## 4. Quote
Motivational quote object.

### JSON Structure
```json
{
  "id": "string",
  "text": "string",
  "author": "string",
  "category": "string (optional)"
}
```
