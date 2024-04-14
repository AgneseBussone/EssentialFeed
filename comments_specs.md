# Image Comments Feature Specs

## Story: Customer requests to see image comments

### Narrative

```
As an online customer
I want the app to load image commments
So I can see how people are engaging with images in my feed
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
 When the customer requests to see comments on an image
 Then the app should display all comments for that image
```

```
Given the customer doesn't have connectivity
 When the customer requests to see comments on an image
 Then the app should display an error message
```

## Use Cases

### Load Image Comments From Remote Use Case

#### Data:

- ImageID

#### Primary course (happy path):

1. Execute "Load Image Comments" command with above data.
2. System loads data from remote service.
3. System validates data.
4. System creates comments from valid data.
5. System delivers comments.

#### Invalid data – error course (sad path):

1. System delivers invalid data error.

#### No connectivity – error course (sad path):

1. System delivers connectivity error.

---

## Model Specs

### Image Comment

| Property          | Type                    |
|-------------------|-------------------------|
| `id`              | `UUID`                  |
| `message`         | `String`                |
| `created_at`      | `Date` (ISO8601 String) |
| `author`          | `CommentAuthorObject`   |

### Image Comment Author

| Property          | Type                |
|-------------------|---------------------|
| `username`        | `String`            |

### Payload contract

```
GET /image/{image-id}/comments

2xx RESPONSE

{
 "items": [
  {
   "id": "a UUID",
   "message": "a message",
   "created_at": "2020-05-20T11:24:59+0000",
   "author": {
    "username": "a username"
   }
  },
  {
   "id": "another UUID",
   "message": "another message",
   "created_at": "2020-05-19T14:23:53+0000",
   "author": {
    "username": "another username"
   }
  },
  ...
 ]
}
```
