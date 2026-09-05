.PHONY: help install test unit-test ui-test lint security qa clean

PYTHON ?= python
PIP ?= $(PYTHON) -m pip
PYTEST ?= $(PYTHON) -m pytest

help:
	@echo "MyTemplate QA Pipeline"
	@echo ""
	@echo "  install     Install project and QA dependencies"
	@echo "  test        Run the complete test suite"
	@echo "  unit-test   Run backend tests with JUnit and coverage reports"
	@echo "  ui-test     Run Playwright UI tests with failure artifacts"
	@echo "  lint        Run Ruff static analysis"
	@echo "  security    Run Bandit security scan"
	@echo "  qa          Run lint, security, unit tests and UI tests"
	@echo "  clean       Remove generated QA artifacts and Python cache files"

install:
	$(PIP) install -r requirements.txt
	$(PYTHON) -m playwright install chromium

test:
	APPNAME_ENV=test $(PYTEST) -q tests

unit-test:
	mkdir -p artifacts/unit artifacts/coverage
	APPNAME_ENV=test $(PYTEST) -q tests/test_*.py \
		--junitxml=artifacts/unit/junit.xml \
		--cov=appname \
		--cov-report=term-missing \
		--cov-report=xml:artifacts/coverage/coverage.xml \
		--cov-report=html:artifacts/coverage/html

ui-test:
	mkdir -p artifacts/playwright
	APPNAME_ENV=test $(PYTEST) -q tests/ui \
		--tracing=retain-on-failure \
		--screenshot=only-on-failure \
		--video=retain-on-failure \
		--output=artifacts/playwright

lint:
	mkdir -p artifacts/lint
	$(PYTHON) -m ruff check appname/services/branding.py tests/test_branding.py tests/ui --output-format=json > artifacts/lint/ruff.json

security:
	mkdir -p artifacts/security
	$(PYTHON) -m bandit -r appname -f json -o artifacts/security/bandit.json

qa: lint security unit-test ui-test

clean:
	rm -rf artifacts
	find . -type d -name "__pycache__" -prune -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
