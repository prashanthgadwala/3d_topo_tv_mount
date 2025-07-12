"""
TV Wall Mount Optimization Framework
===================================

A comprehensive structural optimization system for TV wall mount design.
"""

__version__ = "1.0.0"
__author__ = "Prashanth Gadwala"
__email__ = "your.email@domain.com"

from .core.tv_mount_optimizer import TVMountOptimizer, LoadCase, LoadType, MaterialType
from .utils.mesh_utilities import MeshGenerator, MeshQualityAnalyzer
from .visualization.visualization import ResultsVisualizer

__all__ = [
    'TVMountOptimizer',
    'LoadCase', 
    'LoadType',
    'MaterialType',
    'MeshGenerator',
    'MeshQualityAnalyzer', 
    'ResultsVisualizer'
]
