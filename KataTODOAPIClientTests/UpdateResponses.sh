#!/bin/sh

curl --location --request GET 'https://jsonplaceholder.typicode.com/todos/' \
> "getTasksResponse.json"

curl --location --request GET 'https://jsonplaceholder.typicode.com/todos/1' \
> "getTaskByIdResponse.json"

curl --location --request POST 'https://jsonplaceholder.typicode.com/todos' \
--header 'Content-Type: application/json' \
--data-raw '{
    "userId": 1,
    "title": "Finish this kata",
    "completed": false
}' > "addTaskToUserResponse.json"

curl --location --request POST 'https://jsonplaceholder.typicode.com/todos' \
--header 'Content-Type: application/json' \
--data-raw '{
    "userId": 1,
    "title": "Finish this kata",
    "completed": false
}' > "updateTaskResponse.json"
