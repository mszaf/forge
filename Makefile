IMAGE_NAME='Forge'
VERSION=1.0.0
PYTHON=python3.7


.DEFAULT: help
help:
	@echo "make init"
	@echo "   prepare development environment and create virtualenv"
	@echo "make test"
	@echo "   run lint, pytype and unit tests"
	@echo "make lint"
	@echo "   run lint and pytype only"
	@echo "make build"
	@echo "   run lint, test, and build package"
	@echo "make clean"
	@echo "   clean compiled files and the virtual environment"
	@echo "\n"
	@echo "For Development:"
	@echo "make install"
	@echo "   installs package from source"

init:
	rm -rf .venv
	$(PYTHON) -m pip install virtualenv
	virtualenv --python=$(PYTHON) --always-copy .venv
	( \
    . .venv/bin/activate; \
    pip3 install -r requirements.txt; \
    )

lint:
	( \
    . .venv/bin/activate; \
    pylint -j 4 --rcfile=pylintrc forge; \
    )

build:
	( \
	$(PYTHON) -m pip install --upgrade setuptools wheel; \
	$(PYTHON) setup.py sdist bdist_wheel; \
	)

install: build
	( \
	  $(PYTHON) -m pip install dist/tele_forge-${VERSION}-py3-none-any.whl; \
  )

test:
	$(PYTHON) -m unittest discover -s forge -p '*_test.py'

clean:
	rm -rf forge.egg-info/ build/ dist/ .venv/

type-check:
	pytype *.py forge
