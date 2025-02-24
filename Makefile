# Docker image name
IMAGE_NAME = vraxion_dev

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) .

# Run tests using pytest
test: build
	docker run --rm $(IMAGE_NAME) pytest -s /tests

# Start the server using gunicorn
serve: build
	docker run --rm -p 8000:8000 $(IMAGE_NAME) gunicorn -b 0.0.0.0:8000 vraxion.app:app

# Clean Python build artifacts
pyclean:
	rm -rf src/build src/dist

# Build and publish Python package to PyPI
pypublish:
	cd src && \
	python3 setup.py sdist bdist_wheel && \
	twine check dist/* && \
	twine upload --skip-existing -u ${TWINE_USERNAME} dist/*

# Run all tasks in sequence
all: test pypublish pyclean

.PHONY: build test serve pyclean pypublish all
