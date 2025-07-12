"""
Setup script for TV Wall Mount Optimization Framework
"""

from setuptools import setup, find_packages
import os

# Read the README file
with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

# Read requirements
with open("config/requirements.txt", "r", encoding="utf-8") as fh:
    requirements = [line.strip() for line in fh if line.strip() and not line.startswith("#")]

setup(
    name="tv-wall-mount-optimizer",
    version="1.0.0",
    author="Prashanth Gadwala",
    author_email="your.email@domain.com",
    description="Advanced structural optimization framework for TV wall mount design",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/your-username/tv-wall-mount-optimizer",
    packages=find_packages(),
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Science/Research",
        "Topic :: Scientific/Engineering",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
    ],
    python_requires=">=3.8",
    install_requires=requirements,
    extras_require={
        "dev": [
            "pytest>=6.0",
            "pytest-cov>=2.0",
            "black>=21.0",
            "flake8>=3.8",
            "mypy>=0.900",
        ],
        "docs": [
            "sphinx>=4.0",
            "sphinx-rtd-theme>=1.0",
        ],
    },
    entry_points={
        "console_scripts": [
            "tv-mount-optimizer=src.core.tv_mount_optimizer:main",
        ],
    },
    include_package_data=True,
    package_data={
        "": ["*.yaml", "*.xml", "*.md"],
    },
    keywords="structural-optimization topology-optimization finite-element-analysis engineering",
    project_urls={
        "Bug Reports": "https://github.com/your-username/tv-wall-mount-optimizer/issues",
        "Source": "https://github.com/your-username/tv-wall-mount-optimizer",
        "Documentation": "https://tv-wall-mount-optimizer.readthedocs.io/",
    },
)
