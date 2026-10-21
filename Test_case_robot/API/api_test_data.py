"""Robot variable file: test data of the FakeRESTApi tests.

The test scripts (Test_script/fakerest_api/*.robot) import this file and pass the values as arguments
to the test case keywords - the keywords themselves contain no test data.
"""
import json

BOOKS_PATH = "/api/v1/Books"
AUTHORS_BY_BOOK_PATH = "/api/v1/Authors/authors/books"

NEW_BOOK = json.dumps({
    "id": 201, "title": "QA Test Book", "description": "Created by an automated test",
    "pageCount": 123, "excerpt": "Excerpt of the QA book", "publishDate": "2026-10-21T00:00:00Z",
})
UPDATED_BOOK = json.dumps({
    "id": 1, "title": "Updated Book 1", "description": "Updated by an automated test",
    "pageCount": 321, "excerpt": "Updated excerpt", "publishDate": "2026-10-21T00:00:00Z",
})
WRONG_TYPE_BOOK = json.dumps({
    "id": 202, "title": "Wrong type", "description": "pageCount is text",
    "pageCount": "abc", "excerpt": "x", "publishDate": "2026-10-21T00:00:00Z",
})
MALFORMED_JSON = '{"id": 203, "title": "Missing closing brace"'
