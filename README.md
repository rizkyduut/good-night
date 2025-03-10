# Good Night Service

## Overview

Good Night Service is a RESTful service that allows users to track their sleep patterns. It provides endpoints to record sleep sessions, follow other users, and view sleep records of followed users ranked by sleep duration.

## Features
- Users can clock in and clock out sleep records.
- Users can follow and unfollow other users.
- Users can view sleep records of followed users, sorted by highest sleep duration.

## Assumptions
- A user cannot clock in if there is an ongoing sleep session.
- A user cannot follow themselves.
- Users can retrieve sleep records of people they follow, sorted by sleep duration.
- Instead of viewing the sleep records of followed users from the previous week, this service shows the sleep records from the last 7 days for easier testing.

## Prerequisites
- Ruby 3.4.2
- Rails 7.1+
- SQLite 3

## Installation

1. Clone the repository:
    ```sh
    git clone git@github.com:rizkyduut/tripla-good-night.git
    cd tripla-good-night
    ```
2. Install dependencies:
    ```sh
    bundle install
    ```
3. Set up the database:
    ```sh
    rails db:create db:migrate
    ```
4. Start the server:
    ```sh
    rails s
    ```

## API Endpoints

### User Endpoints

#### Create a new user
```http
POST /users
```
**Request Body:**
```json
{
  "name": "John Wick"
}
```
**Response:**
```json
{
    "id": 1,
    "name": "John Wick"
}
```

### Sleep Record Endpoints

#### Clock In
```http
POST /users/:user_id/sleep-records/clock_in
```
**Response:**
```json
{
  "message": "Success",
  "data": {
    "id": 1,
    "user_id": 1,
    "clock_in": "2025-03-10T02:41:19.201Z",
    "clock_out": null,
    "duration": null
  }
}
```

#### Clock Out
```http
POST /users/:user_id/sleep-records/clock_out
```
**Response:**
```json
{
  "message": "Success",
  "data": {
    "id": 1,
    "user_id": 1,
    "clock_in": "2025-03-10T02:41:19.201Z",
    "clock_out": "2025-03-10T02:42:03.459Z",
    "duration": 44 // in second
  }
}
```

#### View User Sleep Records
```http
GET /users/:user_id/sleep-records
```
**Response:**
```json
{
  "data": [
    {
      "id": 10,
      "user_id": 4,
      "clock_in": "2025-03-10T02:41:19.201Z",
      "clock_out": "2025-03-10T02:42:03.459Z",
      "duration": 44
    },
    {
      "id": 9,
      "user_id": 4,
      "clock_in": "2025-03-09T18:09:13.718Z",
      "clock_out": "2025-03-09T19:15:50.186Z",
      "duration": 3996
    }
  ],
  "pagination": {
    "page": 1,
    "count": 2,
    "limit": 20,
    "in": 2
  }
}
```

### Follow & Unfollow Endpoints

#### Follow a user
```http
POST /users/:user_id/follow
```
**Request Body:**
```json
{
  "followed_id": 4
}
```
**Response:**
```json
{
  "message": "Successfully followed user",
  "data": {
    "id": 4,
    "name": "test1",
    "created_at": "2025-03-06T10:30:55.998Z",
    "updated_at": "2025-03-06T10:30:55.998Z"
  }
}
```

#### Unfollow a user
```http
POST /users/:user_id/unfollow
```
**Request Body:**
```json
{
  "followed_id": 4
}
```
**Response:**
```json
{
  "message": "Successfully unfollowed user"
}
```

### View Sleep Records of Followed Users
```http
GET /users/:user_id/sleep-records/following
```
**Response:**
```json
{
"data": [
    {
      "id": 9,
      "user_id": 4,
      "clock_in": "2025-03-09T18:09:13.718Z",
      "clock_out": "2025-03-09T19:15:50.186Z",
      "duration": 3996
    },
    {
      "id": 1,
      "user_id": 3,
      "clock_in": "2025-03-06T16:28:06.940Z",
      "clock_out": "2025-03-06T16:30:32.645Z",
      "duration": 145
    }
  ],
  "pagination": {
   "page": 1,
   "count": 10,
   "limit": 2,
   "in": 2
  }
}
```

## Pagination
Most list-based endpoints return paginated responses to improve performance. The response includes a `pagination` object with the following fields:

```json
{
  "data": [...],
  "pagination": {
    "page": 1,      // Current page number
    "count": 2,     // Total number of items in the system
    "limit": 20,    // Number of items per page
    "in": 2         // Number of items in the current page
  }
}
```

### Query Parameters:
- `page` (optional) - The page number to retrieve (default: `1`).
- `limit` (optional) - The number of items per page (default: `20`).

### Example Request:
```http
GET /users/:user_id/sleep-records/following?page=1&limit=20
```

## Running Tests
To run tests, use:
```sh
bundle exec rspec
```