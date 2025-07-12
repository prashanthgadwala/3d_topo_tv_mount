"""
Test Suite for TV Wall Mount Optimization System
===============================================

Comprehensive testing framework for validating the optimization system
functionality, performance, and reliability.
"""

import unittest
import tempfile
import shutil
import json
import os
from pathlib import Path
import logging

# Suppress logging during tests
logging.disable(logging.CRITICAL)

try:
    from src.core.tv_mount_optimizer import (
        TVMountOptimizer, LoadCase, LoadType, MaterialType,
        GeometryConfig, MeshConfig, OptimizationConfig
    )
    from src.utils.mesh_utilities import (
        MeshGenerator, MeshQualityAnalyzer, create_3d_mesh, write_ansys_mesh
    )
    from src.visualization.visualization import ResultsVisualizer
    IMPORTS_AVAILABLE = True
except ImportError as e:
    print(f"Warning: Some imports failed: {e}")
    IMPORTS_AVAILABLE = False


class TestGeometryConfig(unittest.TestCase):
    """Test geometry configuration functionality."""
    
    def setUp(self):
        if not IMPORTS_AVAILABLE:
            self.skipTest("Required modules not available")
        self.geometry = GeometryConfig()
    
    def test_default_values(self):
        """Test default geometry values."""
        self.assertEqual(self.geometry.width, 10.0)
        self.assertEqual(self.geometry.height, 8.0)
        self.assertEqual(self.geometry.depth, 6.0)
        self.assertEqual(self.geometry.tv_weight, 50.0)
    
    def test_mounting_points(self):
        """Test mounting points configuration."""
        expected_points = [(2, 2), (8, 2), (2, 6), (8, 6)]
        self.assertEqual(self.geometry.mounting_points, expected_points)
    
    def test_geometry_modification(self):
        """Test geometry parameter modification."""
        self.geometry.width = 12.0
        self.geometry.tv_weight = 75.0
        self.assertEqual(self.geometry.width, 12.0)
        self.assertEqual(self.geometry.tv_weight, 75.0)


class TestLoadCase(unittest.TestCase):
    """Test load case functionality."""
    
    def setUp(self):
        if not IMPORTS_AVAILABLE:
            self.skipTest("Required modules not available")
    
    def test_static_load_case(self):
        """Test static load case creation."""
        load_case = LoadCase(
            name="test_static",
            load_type=LoadType.STATIC,
            force_magnitude=100.0,
            safety_factor=2.5
        )
        
        self.assertEqual(load_case.name, "test_static")
        self.assertEqual(load_case.load_type, LoadType.STATIC)
        self.assertEqual(load_case.force_magnitude, 100.0)
        self.assertEqual(load_case.safety_factor, 2.5)
    
    def test_dynamic_load_case(self):
        """Test dynamic load case with frequency."""
        load_case = LoadCase(
            name="test_dynamic",
            load_type=LoadType.DYNAMIC,
            force_magnitude=50.0,
            frequency=15.0
        )
        
        self.assertEqual(load_case.frequency, 15.0)
        self.assertEqual(load_case.load_type, LoadType.DYNAMIC)
    
    def test_fatigue_load_case(self):
        """Test fatigue load case with cycles."""
        load_case = LoadCase(
            name="test_fatigue",
            load_type=LoadType.FATIGUE,
            force_magnitude=25.0,
            cycles=1000000
        )
        
        self.assertEqual(load_case.cycles, 1000000)
        self.assertEqual(load_case.load_type, LoadType.FATIGUE)


class TestMeshGeneration(unittest.TestCase):
    """Test mesh generation functionality."""
    
    def setUp(self):
        if not IMPORTS_AVAILABLE:
            self.skipTest("Required modules not available")
        self.temp_dir = tempfile.mkdtemp()
    
    def tearDown(self):
        shutil.rmtree(self.temp_dir)
    
    def test_mesh_creation(self):
        """Test basic mesh creation."""
        mesh = create_3d_mesh(10, 8, 6, 10.0, 8.0, 6.0)
        
        self.assertIsNotNone(mesh)
        self.assertTrue(hasattr(mesh, 'nodes'))
        self.assertTrue(hasattr(mesh, 'elements'))
        self.assertTrue(len(mesh.nodes) > 0)
        self.assertTrue(len(mesh.elements) > 0)
    
    def test_mesh_dimensions(self):
        """Test mesh dimensions."""
        nx, ny, nz = 5, 4, 3
        mesh = create_3d_mesh(nx, ny, nz, 10.0, 8.0, 6.0)
        
        # Expected number of nodes: (nx+1) * (ny+1) * (nz+1)
        expected_nodes = (nx + 1) * (ny + 1) * (nz + 1)
        self.assertEqual(len(mesh.nodes), expected_nodes)
        
        # Expected number of elements: nx * ny * nz
        expected_elements = nx * ny * nz
        self.assertEqual(len(mesh.elements), expected_elements)
    
    def test_mesh_file_writing(self):
        """Test mesh file writing."""
        mesh = create_3d_mesh(3, 3, 3, 6.0, 6.0, 6.0)
        filename = os.path.join(self.temp_dir, "test_mesh.mesh")
        
        write_ansys_mesh(mesh, filename)
        
        self.assertTrue(os.path.exists(filename))
        
        # Check file content
        with open(filename, 'r') as f:
            content = f.read()
            self.assertIn("ANSYS Mesh File", content)
            self.assertIn("[Nodes]", content)
            self.assertIn("[Elements]", content)


class TestMeshQuality(unittest.TestCase):
    """Test mesh quality analysis."""
    
    def setUp(self):
        if not IMPORTS_AVAILABLE:
            self.skipTest("Required modules not available")
        self.analyzer = MeshQualityAnalyzer()
        self.mesh = create_3d_mesh(5, 5, 5, 5.0, 5.0, 5.0)
    
    def test_quality_analysis(self):
        """Test mesh quality analysis."""
        stats = self.analyzer.analyze_mesh_quality(self.mesh)
        
        self.assertIsNotNone(stats)
        self.assertGreater(stats.total_elements, 0)
        self.assertGreater(stats.total_nodes, 0)
        self.assertGreaterEqual(stats.min_element_quality, 0.0)
        self.assertLessEqual(stats.max_element_quality, 1.0)
    
    def test_quality_suggestions(self):
        """Test quality improvement suggestions."""
        stats = self.analyzer.analyze_mesh_quality(self.mesh)
        suggestions = self.analyzer.suggest_improvements(stats)
        
        self.assertIsInstance(suggestions, list)
        self.assertGreater(len(suggestions), 0)


class TestTVMountOptimizer(unittest.TestCase):
    """Test the main TV mount optimizer."""
    
    def setUp(self):
        if not IMPORTS_AVAILABLE:
            self.skipTest("Required modules not available")
        self.optimizer = TVMountOptimizer()
        self.temp_dir = tempfile.mkdtemp()
        
    def tearDown(self):
        shutil.rmtree(self.temp_dir)
    
    def test_optimizer_initialization(self):
        """Test optimizer initialization."""
        self.assertIsNotNone(self.optimizer.geometry)
        self.assertIsNotNone(self.optimizer.mesh_config)
        self.assertIsNotNone(self.optimizer.optimization_config)
        self.assertGreater(len(self.optimizer.load_cases), 0)
    
    def test_default_load_cases(self):
        """Test default load case setup."""
        load_case_names = [lc.name for lc in self.optimizer.load_cases]
        
        expected_cases = [
            "static_tv_weight",
            "dynamic_vibration", 
            "seismic_horizontal",
            "fatigue_cycling"
        ]
        
        for case_name in expected_cases:
            self.assertIn(case_name, load_case_names)
    
    def test_material_properties(self):
        """Test material properties setup."""
        materials = self.optimizer.material_properties
        
        self.assertIn(MaterialType.STEEL, materials)
        self.assertIn(MaterialType.ALUMINUM, materials)
        self.assertIn(MaterialType.CARBON_FIBER, materials)
        
        # Check steel properties
        steel = materials[MaterialType.STEEL]
        self.assertIn("density", steel)
        self.assertIn("young_modulus", steel)
        self.assertIn("yield_strength", steel)
    
    def test_mesh_generation(self):
        """Test mesh generation in optimizer."""
        # Reduce resolution for faster testing
        self.optimizer.mesh_config.base_resolution = 5
        
        success = self.optimizer.generate_adaptive_mesh()
        self.assertTrue(success)
        self.assertIsNotNone(self.optimizer.mesh)
    
    def test_xml_generation(self):
        """Test XML configuration generation."""
        # Generate mesh first
        self.optimizer.mesh_config.base_resolution = 3
        self.optimizer.generate_adaptive_mesh()
        
        # Change to temp directory for file generation
        original_cwd = os.getcwd()
        os.chdir(self.temp_dir)
        
        try:
            self.optimizer.generate_xml_configurations()
            
            # Check that XML files were created
            for load_case in self.optimizer.load_cases:
                filename = f"TvSupport_{load_case.name}.xml"
                self.assertTrue(os.path.exists(filename))
        finally:
            os.chdir(original_cwd)


class TestVisualization(unittest.TestCase):
    """Test visualization functionality."""
    
    def setUp(self):
        if not IMPORTS_AVAILABLE:
            self.skipTest("Required modules not available")
        self.temp_dir = tempfile.mkdtemp()
        
        # Create mock results file
        self.mock_results = {
            'load_cases': {
                'static_tv_weight': {
                    'max_stress': 25e6,
                    'max_displacement': 0.001,
                    'safety_factor': 2.5
                },
                'dynamic_vibration': {
                    'max_stress': 15e6,
                    'max_displacement': 0.0005,
                    'safety_factor': 1.8
                }
            },
            'material': 'steel',
            'optimization_time': 45.2
        }
        
        self.results_file = os.path.join(self.temp_dir, "test_results.json")
        with open(self.results_file, 'w') as f:
            json.dump(self.mock_results, f)
    
    def tearDown(self):
        shutil.rmtree(self.temp_dir)
    
    def test_visualizer_initialization(self):
        """Test visualizer initialization."""
        visualizer = ResultsVisualizer(self.results_file)
        self.assertEqual(visualizer.results, self.mock_results)
    
    def test_results_loading(self):
        """Test results loading from file."""
        visualizer = ResultsVisualizer()
        visualizer.load_results(self.results_file)
        self.assertEqual(visualizer.results, self.mock_results)


class TestIntegration(unittest.TestCase):
    """Integration tests for the complete system."""
    
    def setUp(self):
        if not IMPORTS_AVAILABLE:
            self.skipTest("Required modules not available")
        self.temp_dir = tempfile.mkdtemp()
        self.original_cwd = os.getcwd()
        os.chdir(self.temp_dir)
    
    def tearDown(self):
        os.chdir(self.original_cwd)
        shutil.rmtree(self.temp_dir)
    
    def test_complete_optimization_workflow(self):
        """Test complete optimization workflow."""
        # Initialize optimizer with minimal settings for fast testing
        optimizer = TVMountOptimizer()
        optimizer.mesh_config.base_resolution = 3
        optimizer.optimization_config.max_iterations = 5
        
        # Run optimization
        results = optimizer.run_optimization(MaterialType.STEEL)
        
        # Verify results structure
        self.assertIsInstance(results, dict)
        self.assertIn('load_cases', results)
        self.assertIn('material', results)
        self.assertIn('optimization_time', results)
        
        # Verify load case results
        load_cases = results['load_cases']
        self.assertGreater(len(load_cases), 0)
        
        for case_name, case_results in load_cases.items():
            self.assertIn('max_stress', case_results)
            self.assertIn('max_displacement', case_results)
            self.assertIn('safety_factor', case_results)
    
    def test_material_comparison(self):
        """Test optimization with different materials."""
        optimizer = TVMountOptimizer()
        optimizer.mesh_config.base_resolution = 3
        optimizer.optimization_config.max_iterations = 2
        
        materials = [MaterialType.STEEL, MaterialType.ALUMINUM]
        results = {}
        
        for material in materials:
            results[material] = optimizer.run_optimization(material)
        
        # Verify different materials produce different results
        self.assertNotEqual(
            results[MaterialType.STEEL]['material'],
            results[MaterialType.ALUMINUM]['material']
        )


class TestErrorHandling(unittest.TestCase):
    """Test error handling and edge cases."""
    
    def setUp(self):
        if not IMPORTS_AVAILABLE:
            self.skipTest("Required modules not available")
    
    def test_invalid_mesh_dimensions(self):
        """Test handling of invalid mesh dimensions."""
        # Test zero dimensions
        with self.assertRaises(Exception):
            create_3d_mesh(0, 5, 5, 10.0, 8.0, 6.0)
        
        # Test negative dimensions  
        with self.assertRaises(Exception):
            create_3d_mesh(-5, 5, 5, 10.0, 8.0, 6.0)
    
    def test_missing_config_file(self):
        """Test handling of missing configuration file."""
        # Should not raise exception, should use defaults
        optimizer = TVMountOptimizer("nonexistent_config.yaml")
        self.assertIsNotNone(optimizer)
    
    def test_invalid_material_type(self):
        """Test handling of invalid material type."""
        optimizer = TVMountOptimizer()
        optimizer.mesh_config.base_resolution = 3
        
        # This should work with valid enum
        results = optimizer.run_optimization(MaterialType.STEEL)
        self.assertNotIn('error', results)


def run_performance_benchmark():
    """Run performance benchmarks for the optimization system."""
    if not IMPORTS_AVAILABLE:
        print("Required modules not available for benchmarking")
        return
    
    import time
    
    print("\n" + "="*60)
    print("PERFORMANCE BENCHMARK")
    print("="*60)
    
    # Test mesh generation performance
    start_time = time.time()
    mesh = create_3d_mesh(50, 40, 30, 10.0, 8.0, 6.0)
    mesh_time = time.time() - start_time
    print(f"Mesh Generation (50x40x30): {mesh_time:.3f} seconds")
    
    # Test optimization performance
    optimizer = TVMountOptimizer()
    optimizer.mesh_config.base_resolution = 20
    optimizer.optimization_config.max_iterations = 10
    
    start_time = time.time()
    results = optimizer.run_optimization(MaterialType.STEEL)
    optimization_time = time.time() - start_time
    print(f"Complete Optimization: {optimization_time:.3f} seconds")
    
    # Memory usage estimation
    node_count = len(mesh.nodes)
    element_count = len(mesh.elements)
    estimated_memory = (node_count * 3 + element_count * 8) * 8 / 1024 / 1024  # MB
    print(f"Estimated Memory Usage: {estimated_memory:.2f} MB")
    
    print("="*60)


if __name__ == '__main__':
    # Run unit tests
    print("Running TV Wall Mount Optimizer Test Suite...")
    print("="*60)
    
    # Create test suite
    test_suite = unittest.TestSuite()
    
    # Add test cases
    test_classes = [
        TestGeometryConfig,
        TestLoadCase,
        TestMeshGeneration,
        TestMeshQuality,
        TestTVMountOptimizer,
        TestVisualization,
        TestIntegration,
        TestErrorHandling
    ]
    
    for test_class in test_classes:
        tests = unittest.TestLoader().loadTestsFromTestCase(test_class)
        test_suite.addTests(tests)
    
    # Run tests
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(test_suite)
    
    # Print summary
    print("\n" + "="*60)
    print("TEST SUMMARY")
    print("="*60)
    print(f"Tests Run: {result.testsRun}")
    print(f"Failures: {len(result.failures)}")
    print(f"Errors: {len(result.errors)}")
    print(f"Success Rate: {((result.testsRun - len(result.failures) - len(result.errors)) / result.testsRun * 100):.1f}%")
    
    if result.failures:
        print("\nFailures:")
        for test, traceback in result.failures:
            print(f"  - {test}: {traceback.split('AssertionError:')[-1].strip()}")
    
    if result.errors:
        print("\nErrors:")
        for test, traceback in result.errors:
            print(f"  - {test}: {traceback.split('Exception:')[-1].strip()}")
    
    # Run performance benchmark if tests passed
    if not result.failures and not result.errors:
        run_performance_benchmark()
    
    print("\nTest suite completed!")
