def test_home_contains_mytemplate_branding(testapp):
    response = testapp.get("/")

    assert response.status_code == 200
    assert b"MyTemplate" in response.data
