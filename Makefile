.PHONY: clean build run test help

# Python virtual environment
VENV = venv
PYTHON = $(VENV)/bin/python
PIP = $(VENV)/bin/pip

help:
	@echo "Available targets:"
	@echo "  make clean  - Remove generated G-code files and Python cache"
	@echo "  make build  - Install dependencies from requirements.txt"
	@echo "  make run    - Run local G-code generation (processes all SVG files)"
	@echo "  make test   - Validate workflow setup"
	@echo "  make help   - Display this help message"

clean:
	@echo "Cleaning generated files..."
	find . -type f -name "*.gcode" -not -path "./.git/*" -delete
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	@echo "Clean complete."

build: $(VENV)
	@echo "Installing dependencies..."
	$(PIP) install -r requirements.txt
	@echo "Build complete."

$(VENV):
	@echo "Creating virtual environment..."
	python3 -m venv $(VENV)
	@echo "Virtual environment created."

run: build
	@echo "Generating G-code from SVG files..."
	@if [ ! -d "$(VENV)" ]; then $(MAKE) build; fi
	@for svg in $$(find . -name "*.svg" -not -path "./.git/*" -not -path "./$(VENV)/*"); do \
		basename=$$(basename "$$svg" .svg); \
		output="$${basename}_combined.gcode"; \
		echo "Processing $$svg -> $$output"; \
		$(PYTHON) -m laser.combine_cut_engrave "$$svg" \
			--engrave-cutting-speed 1000 \
			--engrave-power 75 \
			--cut-cutting-speed 250 \
			--cut-power 255 \
			--travel-speed 3000 \
			-o "$$output" || echo "Failed to process $$svg"; \
	done
	@echo "G-code generation complete."

test: build
	@echo "Validating setup..."
	@$(PYTHON) -c "import laser; print('laser-tool imported successfully')" || (echo "Error: laser-tool not installed correctly" && exit 1)
	@echo "Setup validation complete."
