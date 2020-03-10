![Karumi logo][karumilogo] KataTODOApiClient for iOS. [![Build Status](https://travis-ci.org/Karumi/KataTODOApiClientIOS.svg?branch=master)](https://travis-ci.org/Karumi/KataTODOApiClientIOS)
============================

- We are here to practice integration testing using HTTP stubbing.
- We are going to use [OHHTTPStubs][OHHTTPStubs] to simulate a HTTP server.
- We are going to use [Nimble][nimble] to perform assertions.
- We are going to practice pair programming.

---

## Getting started

This repository contains an API client to interact with a remote service we can use to implement a TODO application.

This APIClient is based on one class with name ``TODOAPIClient`` containing some methos to interact with the API. Using this class we can get all the tasks we have created before, get a task using the task id, add a new task, update a task or delete an already created task.

The API client has been implemented using a networking framework named [Alamofire][alamofire]. Review the project documentation if needed.

## Tasks

Your task as iOS Developer is to **write all the integration tests** needed to check if the API Client is working as it should. 

**This repository is ready to build the application, pass the checkstyle and your tests in Travis-CI environments.**

Our recommendation for this exercise is:

  * Before starting
    1. Fork this repository.
    2. Checkout `kata-todo-api-client` branch.
    3. Execute the repository playground and make yourself familiar with the code.
    4. Execute `TODOAPIClientTests` and watch the only test it contains pass.

  * To help you get started, these are some tests already written at `TODOAPIClientTests` class. Review it carefully before to start writing your own tests. Here you have the description of some tests you can write to start working on this Kata:
	1. Test that the ``Accept`` and ``ContentType`` headers are sent.
    2. Test that the list of ``TaskDTO`` instances obtained invoking the method ``getAllTasks``  contains the expected values.
    3. Test that if there is no connection the error returned by any method call is ``TODOAPIClientError.NetworkError``.
    4. Test that adding a task the body sent to the server is the correct one.

## Considerations

* If you get stuck, `master` branch contains all the tests already solved.

## Extra Tasks

If you've covered all the application functionality using integration tests you can continue with some extra tasks: 

* Replace some integration tests we have created with unit tests. A starting point could be the ``mapErrorToTODOAPIClientError`` function or the ``DefaultHeadersInterceptor`` class.
* Create your own API client to consume one of the services described in this web: [http://jsonplaceholder.typicode.com/][jsonplaceholder]

---

## Documentation

There are some links which can be useful to finish these tasks:

* [Nocilla official documentation][nocilla]
* [Nimble documentation][nimble]
* [Alamofire documentation][alamofire-documentation]
* [World-Class Testing Development Pipeline for Android - Part 3][wordl-class-testing-development-pipeline]

[karumilogo]: https://cloud.githubusercontent.com/assets/858090/11626547/e5a1dc66-9ce3-11e5-908d-537e07e82090.png
[OHHTTPStubs]: https://github.com/AliSoftware/OHHTTPStubs
[nimble]: https://github.com/Quick/Nimble
[testDoubles]: http://www.martinfowler.com/bliki/TestDouble.html
[jsonplaceholder]: http://jsonplaceholder.typicode.com/
[wordl-class-testing-development-pipeline]: http://blog.karumi.com/world-class-testing-development-pipeline-for-android-part-3/
[alamofire]: https://github.com/Alamofire/Alamofire
[alamofire-documentation]: https://alamofire.github.io/Alamofire/
