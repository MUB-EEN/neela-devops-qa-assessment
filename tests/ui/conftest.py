from threading import Thread

import pytest
from werkzeug.serving import make_server

from appname import create_app


@pytest.fixture(scope="session")
def live_server():
    app = create_app("appname.settings.TestConfig")
    server = make_server("127.0.0.1", 5000, app)
    thread = Thread(target=server.serve_forever, daemon=True)
    thread.start()

    yield "http://127.0.0.1:5000"

    server.shutdown()
    thread.join()
