# TV Wall Mount Optimizer - Development Makefile

.PHONY: help install test format clean demo

# Default target
help:
	@echo "TV Wall Mount Optimizer - Development Commands"
	@echo "============================================="
	@echo ""
	@echo "Commands:"
	@echo "  install       Install dependencies"
	@echo "  test          Run all tests"
	@echo "  demo          Run the interactive demo"
	@echo "  format        Format code"
	@echo "  clean         Clean build artifacts"

# Installation
install:
	pip install -r config/requirements.txt

# Testing
test:
	python -m pytest tests/ -v

# Code quality
format:
	python -m black src/ tests/ examples/

# Development
demo:
	python examples/demo.py

# Build and cleanup
clean:
	rm -rf build/ dist/ *.egg-info/
	rm -rf .pytest_cache/ htmlcov/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
