"""
Mesh Tool Compatibility Layer
============================

This module provides compatibility with the original mesh_tool import
while adding enhanced functionality.
"""

# Import from our enhanced mesh utilities
from mesh_utilities import (
    create_3d_mesh,
    write_ansys_mesh,
    MeshGenerator,
    MeshQualityAnalyzer,
    AdaptiveMeshRefinement,
    analyze_mesh_connectivity,
    validate_mesh_integrity
)

# Expose the main functions that the original code expects
__all__ = [
    'create_3d_mesh',
    'write_ansys_mesh',
    'MeshGenerator',
    'MeshQualityAnalyzer',
    'AdaptiveMeshRefinement',
    'analyze_mesh_connectivity',
    'validate_mesh_integrity'
]
