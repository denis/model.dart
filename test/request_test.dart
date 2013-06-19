part of model_tests;

void requestTest() {
  group("Request tests:", () {
    Request request;

    setUp(() {
      HttpRequestMaybeMock.useMock = true;
      request = new Request("some-host", 1234, "http", "/path/to");
    });

    test("make a get request", () {
      var future = request.get(new ChangeableUri.fromString("/projects/123"));
      future.then(expectAsync1((requestParams) {
        expect(requestParams, equals({
          "requestHeaders": {"Content-Type": "application/json"},
          "method": "GET",
          "uri": "http://some-host:1234/path/to/projects/123",
          "data": null,
          "status": 200
        }));
      }));
    });

    test("adds params to the Uri when making a get request", () {
      var future = request.get(new ChangeableUri.fromString("/projects/123"), {"foo": "bar", "bla": null});
      future.then(expectAsync1((requestParams) {
        expect(requestParams["uri"], equals("http://some-host:1234/path/to/projects/123?foo=bar"));
      }));
    });

    test("make a post request", () {
      var future = request.post(new ChangeableUri.fromString("/projects"), {"foo": "bar"});
      future.then(expectAsync1((requestParams) {
        expect(requestParams, equals({
          "requestHeaders": {"Content-Type": "application/json"},
          "method": "POST",
          "uri": "http://some-host:1234/path/to/projects",
          "data": '{"foo":"bar"}',
          "status": 200
        }));
      }));
    });

    test("make a put request", () {
      var future = request.put(new ChangeableUri.fromString("/projects/123"), {"foo": "bar"});
      future.then(expectAsync1((requestParams) {
        expect(requestParams, equals({
          "requestHeaders": {"Content-Type": "application/json"},
          "method": "PUT",
          "uri": "http://some-host:1234/path/to/projects/123",
          "data": '{"_method":"PUT","foo":"bar"}',
          "status": 200
        }));
      }));
    });

    test("make a delete request", () {
      var future = request.delete(new ChangeableUri.fromString("/projects/123"));
      future.then(expectAsync1((requestParams) {
        expect(requestParams, equals({
          "requestHeaders": {"Content-Type": "application/json"},
          "method": "DELETE",
          "uri": "http://some-host:1234/path/to/projects/123",
          "data": '{"_method":"DELETE"}',
          "status": 200
        }));
      }));
    });
  });
}
