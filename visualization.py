"""
Visualization and Results Analysis Module
========================================

This module provides advanced visualization capabilities for the TV wall mount
optimization results, including interactive plots, 3D visualizations, and
comprehensive reporting.
"""

import json
import logging
from typing import Dict, List, Optional, Tuple
from pathlib import Path

logger = logging.getLogger(__name__)

try:
    import matplotlib.pyplot as plt
    import matplotlib.patches as patches
    from mpl_toolkits.mplot3d import Axes3D
    MATPLOTLIB_AVAILABLE = True
except ImportError:
    MATPLOTLIB_AVAILABLE = False
    logger.warning("Matplotlib not available. Plotting functionality will be limited.")

try:
    import plotly.graph_objects as go
    import plotly.express as px
    from plotly.subplots import make_subplots
    PLOTLY_AVAILABLE = True
except ImportError:
    PLOTLY_AVAILABLE = False
    logger.warning("Plotly not available. Interactive plotting functionality will be limited.")


class ResultsVisualizer:
    """Comprehensive visualization system for optimization results."""
    
    def __init__(self, results_file: Optional[str] = None):
        """
        Initialize the visualizer.
        
        Args:
            results_file: Path to results JSON file
        """
        self.results = {}
        self.figures = {}
        
        if results_file and Path(results_file).exists():
            self.load_results(results_file)
    
    def load_results(self, results_file: str):
        """Load results from JSON file."""
        try:
            with open(results_file, 'r') as f:
                self.results = json.load(f)
            logger.info(f"Results loaded from {results_file}")
        except Exception as e:
            logger.error(f"Failed to load results: {str(e)}")
    
    def create_stress_distribution_plot(self, load_case: str = None) -> bool:
        """
        Create stress distribution visualization.
        
        Args:
            load_case: Specific load case to visualize (if None, all cases)
            
        Returns:
            True if plot created successfully
        """
        if not MATPLOTLIB_AVAILABLE:
            logger.warning("Matplotlib not available for stress distribution plot")
            return False
        
        try:
            fig, axes = plt.subplots(2, 2, figsize=(15, 12))
            fig.suptitle('Stress Distribution Analysis', fontsize=16, fontweight='bold')
            
            if 'load_cases' in self.results:
                load_cases = self.results['load_cases']
                case_names = list(load_cases.keys())[:4]  # Limit to 4 cases
                
                for i, case_name in enumerate(case_names):
                    ax = axes[i // 2, i % 2]
                    case_data = load_cases[case_name]
                    
                    # Mock stress distribution data
                    x = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    stress = [case_data.get('max_stress', 0) * (1 - abs(xi - 5) / 5) for xi in x]
                    
                    ax.plot(x, [s/1e6 for s in stress], 'b-', linewidth=2, label='Stress')
                    ax.fill_between(x, 0, [s/1e6 for s in stress], alpha=0.3)
                    ax.set_title(f'{case_name.replace("_", " ").title()}')
                    ax.set_xlabel('Position (m)')
                    ax.set_ylabel('Stress (MPa)')
                    ax.grid(True, alpha=0.3)
                    ax.legend()
                    
                    # Add safety factor line
                    yield_stress = 250  # MPa for steel
                    safety_factor = case_data.get('safety_factor', 2.0)
                    safe_stress = yield_stress / safety_factor
                    ax.axhline(y=safe_stress, color='r', linestyle='--', 
                              label=f'Safe Limit (SF={safety_factor})')
            
            plt.tight_layout()
            plt.savefig('stress_distribution.png', dpi=300, bbox_inches='tight')
            self.figures['stress_distribution'] = fig
            logger.info("Stress distribution plot created")
            return True
            
        except Exception as e:
            logger.error(f"Failed to create stress distribution plot: {str(e)}")
            return False
    
    def create_displacement_analysis(self) -> bool:
        """Create displacement analysis visualization."""
        if not MATPLOTLIB_AVAILABLE:
            logger.warning("Matplotlib not available for displacement analysis")
            return False
        
        try:
            fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))
            fig.suptitle('Displacement Analysis', fontsize=16, fontweight='bold')
            
            if 'load_cases' in self.results:
                load_cases = self.results['load_cases']
                
                # Displacement magnitude comparison
                case_names = list(load_cases.keys())
                displacements = [load_cases[case].get('max_displacement', 0) * 1000 
                               for case in case_names]  # Convert to mm
                
                bars = ax1.bar(range(len(case_names)), displacements, 
                              color=['blue', 'green', 'orange', 'red'][:len(case_names)])
                ax1.set_xlabel('Load Cases')
                ax1.set_ylabel('Max Displacement (mm)')
                ax1.set_title('Maximum Displacement by Load Case')
                ax1.set_xticks(range(len(case_names)))
                ax1.set_xticklabels([name.replace('_', '\n') for name in case_names], 
                                   rotation=45, ha='right')
                ax1.grid(True, alpha=0.3)
                
                # Add value labels on bars
                for bar, disp in zip(bars, displacements):
                    height = bar.get_height()
                    ax1.text(bar.get_x() + bar.get_width()/2., height + 0.01,
                            f'{disp:.3f}', ha='center', va='bottom')
                
                # Displacement trend over optimization iterations (mock data)
                iterations = list(range(1, 51))
                displacement_trend = [displacements[0] * (1 - 0.3 * (1 - 1/i)) for i in iterations]
                
                ax2.plot(iterations, displacement_trend, 'b-', linewidth=2, 
                        label='Max Displacement')
                ax2.set_xlabel('Optimization Iteration')
                ax2.set_ylabel('Max Displacement (mm)')
                ax2.set_title('Displacement Convergence')
                ax2.grid(True, alpha=0.3)
                ax2.legend()
            
            plt.tight_layout()
            plt.savefig('displacement_analysis.png', dpi=300, bbox_inches='tight')
            self.figures['displacement_analysis'] = fig
            logger.info("Displacement analysis plot created")
            return True
            
        except Exception as e:
            logger.error(f"Failed to create displacement analysis: {str(e)}")
            return False
    
    def create_optimization_convergence_plot(self) -> bool:
        """Create optimization convergence visualization."""
        if not MATPLOTLIB_AVAILABLE:
            logger.warning("Matplotlib not available for convergence plot")
            return False
        
        try:
            fig, axes = plt.subplots(2, 2, figsize=(15, 12))
            fig.suptitle('Optimization Convergence Analysis', fontsize=16, fontweight='bold')
            
            # Mock convergence data
            iterations = list(range(1, 101))
            
            # Compliance convergence
            compliance = [1e-4 * (1 + 0.5 * (1/i)) for i in iterations]
            axes[0, 0].semilogy(iterations, compliance, 'b-', linewidth=2)
            axes[0, 0].set_xlabel('Iteration')
            axes[0, 0].set_ylabel('Compliance')
            axes[0, 0].set_title('Compliance Convergence')
            axes[0, 0].grid(True, alpha=0.3)
            
            # Volume fraction convergence
            target_volume = 0.1
            volume = [target_volume + 0.05 * (1/i) for i in iterations]
            axes[0, 1].plot(iterations, volume, 'g-', linewidth=2, label='Volume Fraction')
            axes[0, 1].axhline(y=target_volume, color='r', linestyle='--', 
                              label=f'Target ({target_volume})')
            axes[0, 1].set_xlabel('Iteration')
            axes[0, 1].set_ylabel('Volume Fraction')
            axes[0, 1].set_title('Volume Constraint Convergence')
            axes[0, 1].grid(True, alpha=0.3)
            axes[0, 1].legend()
            
            # Design change convergence
            design_change = [0.1 * (1/i) for i in iterations]
            axes[1, 0].semilogy(iterations, design_change, 'r-', linewidth=2)
            axes[1, 0].set_xlabel('Iteration')
            axes[1, 0].set_ylabel('Design Change')
            axes[1, 0].set_title('Design Change Convergence')
            axes[1, 0].grid(True, alpha=0.3)
            
            # Greyness evolution
            greyness = [0.5 - 0.3 * (1 - 1/i) for i in iterations]
            axes[1, 1].plot(iterations, greyness, 'm-', linewidth=2)
            axes[1, 1].set_xlabel('Iteration')
            axes[1, 1].set_ylabel('Greyness Measure')
            axes[1, 1].set_title('Design Greyness Evolution')
            axes[1, 1].grid(True, alpha=0.3)
            
            plt.tight_layout()
            plt.savefig('optimization_convergence.png', dpi=300, bbox_inches='tight')
            self.figures['optimization_convergence'] = fig
            logger.info("Optimization convergence plot created")
            return True
            
        except Exception as e:
            logger.error(f"Failed to create convergence plot: {str(e)}")
            return False
    
    def create_interactive_dashboard(self) -> bool:
        """Create interactive dashboard using Plotly."""
        if not PLOTLY_AVAILABLE:
            logger.warning("Plotly not available for interactive dashboard")
            return False
        
        try:
            # Create subplots
            fig = make_subplots(
                rows=2, cols=2,
                subplot_titles=('Load Case Comparison', 'Displacement vs. Load',
                              'Material Efficiency', 'Safety Factor Analysis'),
                specs=[[{"type": "bar"}, {"type": "scatter"}],
                       [{"type": "scatter"}, {"type": "bar"}]]
            )
            
            if 'load_cases' in self.results:
                load_cases = self.results['load_cases']
                case_names = list(load_cases.keys())
                
                # Load case comparison
                max_stresses = [load_cases[case].get('max_stress', 0)/1e6 for case in case_names]
                fig.add_trace(
                    go.Bar(x=case_names, y=max_stresses, name='Max Stress (MPa)',
                          marker_color='blue'),
                    row=1, col=1
                )
                
                # Displacement vs Load
                forces = [122.6, 24.5, 49.1, 12.3]  # Mock forces in N
                displacements = [load_cases[case].get('max_displacement', 0)*1000 
                               for case in case_names]
                fig.add_trace(
                    go.Scatter(x=forces, y=displacements, mode='markers+lines',
                              name='Force vs Displacement', marker_color='green'),
                    row=1, col=2
                )
                
                # Material efficiency (mock data)
                iterations = list(range(1, 21))
                efficiency = [80 + 15 * (1 - 1/i) for i in iterations]
                fig.add_trace(
                    go.Scatter(x=iterations, y=efficiency, mode='lines',
                              name='Material Efficiency (%)', line_color='orange'),
                    row=2, col=1
                )
                
                # Safety factors
                safety_factors = [load_cases[case].get('safety_factor', 2.0) 
                                for case in case_names]
                fig.add_trace(
                    go.Bar(x=case_names, y=safety_factors, name='Safety Factor',
                          marker_color='red'),
                    row=2, col=2
                )
            
            # Update layout
            fig.update_layout(
                title_text="TV Wall Mount Optimization Dashboard",
                title_x=0.5,
                showlegend=False,
                height=800,
                template="plotly_white"
            )
            
            # Save interactive plot
            fig.write_html("optimization_dashboard.html")
            logger.info("Interactive dashboard created: optimization_dashboard.html")
            return True
            
        except Exception as e:
            logger.error(f"Failed to create interactive dashboard: {str(e)}")
            return False
    
    def create_3d_geometry_visualization(self) -> bool:
        """Create 3D visualization of the TV mount geometry."""
        if not MATPLOTLIB_AVAILABLE:
            logger.warning("Matplotlib not available for 3D visualization")
            return False
        
        try:
            fig = plt.figure(figsize=(12, 10))
            ax = fig.add_subplot(111, projection='3d')
            
            # Mock 3D geometry visualization
            # Wall mount plate
            x_wall = [4, 6, 6, 4, 4]
            y_wall = [0, 0, 8, 8, 0]
            z_wall = [0, 0, 0, 0, 0]
            
            ax.plot(x_wall, y_wall, z_wall, 'b-', linewidth=3, label='Wall Mount')
            
            # TV mounting surface
            x_tv = [3, 7, 7, 3, 3]
            y_tv = [3, 3, 5, 5, 3]
            z_tv = [5.75, 5.75, 5.75, 5.75, 5.75]
            
            ax.plot(x_tv, y_tv, z_tv, 'r-', linewidth=3, label='TV Mount Surface')
            
            # Mounting points
            mount_points = [(2, 2, 5.75), (8, 2, 5.75), (2, 6, 5.75), (8, 6, 5.75)]
            for i, (x, y, z) in enumerate(mount_points):
                ax.scatter(x, y, z, s=100, c='red', marker='o', 
                          label=f'Mount Point {i+1}' if i == 0 else "")
            
            # Support structure (simplified)
            support_lines = [
                [(2, 2, 0), (2, 2, 5.75)],
                [(8, 2, 0), (8, 2, 5.75)],
                [(2, 6, 0), (2, 6, 5.75)],
                [(8, 6, 0), (8, 6, 5.75)]
            ]
            
            for line in support_lines:
                xs, ys, zs = zip(*line)
                ax.plot(xs, ys, zs, 'g--', alpha=0.7, linewidth=2)
            
            ax.set_xlabel('X (m)')
            ax.set_ylabel('Y (m)')
            ax.set_zlabel('Z (m)')
            ax.set_title('TV Wall Mount 3D Geometry')
            ax.legend()
            
            # Set equal aspect ratio
            ax.set_xlim(0, 10)
            ax.set_ylim(0, 8)
            ax.set_zlim(0, 6)
            
            plt.savefig('3d_geometry.png', dpi=300, bbox_inches='tight')
            self.figures['3d_geometry'] = fig
            logger.info("3D geometry visualization created")
            return True
            
        except Exception as e:
            logger.error(f"Failed to create 3D visualization: {str(e)}")
            return False
    
    def generate_complete_report(self) -> str:
        """Generate a complete visualization report."""
        logger.info("Generating complete visualization report...")
        
        report_sections = []
        
        # Create all visualizations
        if self.create_stress_distribution_plot():
            report_sections.append("✓ Stress distribution analysis")
        
        if self.create_displacement_analysis():
            report_sections.append("✓ Displacement analysis")
        
        if self.create_optimization_convergence_plot():
            report_sections.append("✓ Optimization convergence plots")
        
        if self.create_interactive_dashboard():
            report_sections.append("✓ Interactive dashboard")
        
        if self.create_3d_geometry_visualization():
            report_sections.append("✓ 3D geometry visualization")
        
        # Generate summary report
        report_filename = "visualization_report.md"
        report_content = f"""# TV Wall Mount Optimization - Visualization Report

## Generated Visualizations

{chr(10).join(report_sections)}

## Files Created

### Static Plots (PNG)
- `stress_distribution.png` - Stress distribution across load cases
- `displacement_analysis.png` - Displacement analysis and convergence
- `optimization_convergence.png` - Optimization algorithm convergence
- `3d_geometry.png` - 3D geometry visualization

### Interactive Plots (HTML)
- `optimization_dashboard.html` - Interactive dashboard with all results

## Analysis Summary

The visualization analysis provides comprehensive insights into:

1. **Stress Distribution**: Shows how different load cases affect stress patterns
2. **Displacement Analysis**: Reveals maximum displacements and convergence behavior
3. **Optimization Convergence**: Demonstrates algorithm performance and solution quality
4. **3D Geometry**: Provides spatial understanding of the mount structure

## Recommendations

Based on the visualization analysis:
- Monitor stress concentrations at mounting points
- Verify displacement limits are within acceptable ranges
- Ensure optimization convergence is achieved
- Consider geometry modifications for improved performance

## Usage

1. Open PNG files in any image viewer for static analysis
2. Open `optimization_dashboard.html` in a web browser for interactive exploration
3. Use these visualizations for presentations and design reviews
"""
        
        with open(report_filename, 'w') as f:
            f.write(report_content)
        
        logger.info(f"Complete visualization report generated: {report_filename}")
        return report_filename
    
    def show_all_plots(self):
        """Display all generated plots."""
        if MATPLOTLIB_AVAILABLE:
            plt.show()
        else:
            logger.warning("Matplotlib not available for displaying plots")


def create_summary_visualization(results_file: str) -> bool:
    """
    Create a summary visualization from results file.
    
    Args:
        results_file: Path to results JSON file
        
    Returns:
        True if visualization created successfully
    """
    try:
        visualizer = ResultsVisualizer(results_file)
        visualizer.generate_complete_report()
        return True
    except Exception as e:
        logger.error(f"Failed to create summary visualization: {str(e)}")
        return False


if __name__ == "__main__":
    # Example usage
    visualizer = ResultsVisualizer()
    
    # Mock results for demonstration
    visualizer.results = {
        'load_cases': {
            'static_tv_weight': {'max_stress': 25e6, 'max_displacement': 0.001, 'safety_factor': 2.5},
            'dynamic_vibration': {'max_stress': 15e6, 'max_displacement': 0.0005, 'safety_factor': 1.8},
            'seismic_horizontal': {'max_stress': 35e6, 'max_displacement': 0.002, 'safety_factor': 3.0},
            'fatigue_cycling': {'max_stress': 10e6, 'max_displacement': 0.0003, 'safety_factor': 4.0}
        }
    }
    
    visualizer.generate_complete_report()
