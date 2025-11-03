 #!/usr/bin/env bash

# ==============================================================================
# Advanced Interactive Topology Optimization Runner for TV Wall Mount
# ==============================================================================
# This version allows customization of:
#   - Mesh resolution (nx, ny, nz)
#   - Material selection
#   - Volume fraction
#   - SIMP penalty and filter radius
#   - Solver selection
# ==============================================================================

set -e  # Exit on error

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Project paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_DIR="$PROJECT_ROOT/results"
MESHES_DIR="$RESULTS_DIR/meshes"
OUTPUTS_DIR="$RESULTS_DIR/outputs"

# Default parameters (will be customized by user)
MESH_PRESET="medium"
NX=50
NY=40
NZ=30
MATERIAL="99lines"
VOLFRAC=0.25
SIMP_P=3.0
FILTER_RMIN=0.05
SOLVER="cholmod"
SOLVER_NAME="CHOLMOD"

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

print_header() {
    echo ""
    printf "${CYAN}═══════════════════════════════════════════════════════════════${NC}\n"
    printf "${CYAN}%s${NC}\n" "$1"
    printf "${CYAN}═══════════════════════════════════════════════════════════════${NC}\n"
    echo ""
}

print_step() {
    printf "${GREEN}▶${NC} ${BOLD}%s${NC}\n" "$1"
}

print_warning() {
    printf "${YELLOW}⚠${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}✗${NC} %s\n" "$1"
}

print_success() {
    printf "${GREEN}✓${NC} %s\n" "$1"
}

print_info() {
    printf "${BLUE}ℹ${NC} %s\n" "$1"
}

# ==============================================================================
# MAIN MENU
# ==============================================================================

show_main_menu() {
    clear
    print_header "TV WALL MOUNT TOPOLOGY OPTIMIZATION"
    
    printf "${BOLD}Choose your optimization mode:${NC}\n"
    echo ""
    printf "${GREEN}[1] Quick Run${NC} ⚡\n"
    echo "    Use default settings for fast optimization"
    echo "    └─ Medium mesh (50×40×30), 25% volume, CHOLMOD solver"
    echo ""
    printf "${CYAN}[2] Custom Parameters${NC} ⚙️\n"
    echo "    Customize mesh, material, optimization settings"
    echo "    └─ Interactive menu for all parameters"
    echo ""
    printf "${MAGENTA}[3] Parameter Study${NC} 📊\n"
    echo "    Run multiple optimizations with varying parameters"
    echo "    └─ Compare volume fractions or materials"
    echo ""
    printf "${YELLOW}[4] View Documentation${NC} 📖\n"
    echo "    Open customization guide in terminal"
    echo ""
    printf "${BLUE}[Q] Quit${NC}\n"
    echo ""
}

get_main_choice() {
    while true; do
        printf "${BOLD}Enter your choice [1-4/Q]: ${NC}"
        read -r choice
        choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')
        
        case $choice in
            1) return 1 ;;  # Quick run
            2) return 2 ;;  # Custom
            3) return 3 ;;  # Parameter study
            4) return 4 ;;  # Documentation
            Q) 
                clear
                echo ""
                print_success "Thanks for using the optimizer!"
                echo ""
                printf "${CYAN}═══════════════════════════════════════════════════════════════${NC}\n"
                printf "${GREEN}✓${NC} Your terminal is ready for your next command\n"
                printf "${CYAN}═══════════════════════════════════════════════════════════════${NC}\n"
                echo ""
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please enter 1, 2, 3, 4, or Q."
                ;;
        esac
    done
}

# ==============================================================================
# MESH CONFIGURATION
# ==============================================================================

show_mesh_menu() {
    print_header "MESH RESOLUTION CONFIGURATION"
    
    printf "${BOLD}Select mesh density preset:${NC}\n"
    echo ""
    printf "${GREEN}[1] Coarse${NC} - Fast prototyping\n"
    echo "    40×32×24 = 30,720 elements"
    echo "    Solve time: ~30 seconds per iteration"
    echo "    Best for: Initial exploration, testing"
    echo ""
    printf "${CYAN}[2] Medium${NC} ⭐ Recommended\n"
    echo "    50×40×30 = 60,000 elements"
    echo "    Solve time: ~45 seconds per iteration"
    echo "    Best for: Development, most projects"
    echo ""
    printf "${YELLOW}[3] Fine${NC} - High detail\n"
    echo "    80×64×48 = 245,760 elements"
    echo "    Solve time: ~3 minutes per iteration"
    echo "    Best for: Final validation, publications"
    echo ""
    printf "${MAGENTA}[4] Ultra-Fine${NC} - Maximum quality\n"
    echo "    120×96×72 = 829,440 elements"
    echo "    Solve time: ~10 minutes per iteration"
    echo "    Best for: Manufacturing-ready designs"
    echo ""
    printf "${BLUE}[5] Custom${NC} - Specify your own nx, ny, nz\n"
    echo ""
}

get_mesh_choice() {
    while true; do
        printf "${BOLD}Enter mesh preset [1-5]: ${NC}"
        read -r choice
        
        case $choice in
            1) 
                MESH_PRESET="coarse"
                NX=40; NY=32; NZ=24
                break
                ;;
            2) 
                MESH_PRESET="medium"
                NX=50; NY=40; NZ=30
                break
                ;;
            3) 
                MESH_PRESET="fine"
                NX=80; NY=64; NZ=48
                break
                ;;
            4) 
                MESH_PRESET="ultra"
                NX=120; NY=96; NZ=72
                break
                ;;
            5) 
                get_custom_mesh_values
                break
                ;;
            *)
                print_error "Invalid choice. Please enter 1-5."
                ;;
        esac
    done
    
    print_success "Mesh selected: ${BOLD}${NX}×${NY}×${NZ}${NC} = $((NX*NY*NZ)) elements"
}

get_custom_mesh_values() {
    echo ""
    print_info "Enter custom mesh resolution (maintains 10:8:6 aspect ratio)"
    
    while true; do
        printf "${BOLD}Enter NX (width elements, 20-200): ${NC}"
        read -r nx_input
        if [[ "$nx_input" =~ ^[0-9]+$ ]] && [ "$nx_input" -ge 20 ] && [ "$nx_input" -le 200 ]; then
            NX=$nx_input
            NY=$(( NX * 8 / 10 ))
            NZ=$(( NX * 6 / 10 ))
            MESH_PRESET="custom"
            print_success "Custom mesh: ${NX}×${NY}×${NZ} = $((NX*NY*NZ)) elements"
            break
        else
            print_error "Please enter a number between 20 and 200"
        fi
    done
}

# ==============================================================================
# MATERIAL SELECTION
# ==============================================================================

show_material_menu() {
    print_header "MATERIAL SELECTION"
    
    printf "${BOLD}Select material for optimization:${NC}\n"
    echo ""
    printf "${GREEN}[1] 99lines${NC} ⭐ (Normalized - Default)\n"
    echo "    E = 1 GPa, ν = 0.3, ρ = 1e-8 kg/m³"
    echo "    Best for: Academic studies, testing"
    echo ""
    printf "${CYAN}[2] Steel${NC}\n"
    echo "    E = 200 GPa, ν = 0.29, ρ = 7872 kg/m³"
    echo "    Best for: Metal fabrication, welded structures"
    echo ""
    printf "${YELLOW}[3] Aluminium${NC}\n"
    echo "    E = 107.8 GPa, ν = 0.3, ρ = 2700 kg/m³"
    echo "    Best for: Lightweight design, CNC machining"
    echo ""
    printf "${MAGENTA}[4] Titanium${NC}\n"
    echo "    E = 110 GPa, ν = 0.32, ρ = 4506 kg/m³"
    echo "    Best for: High-end applications, 3D printing"
    echo ""
    printf "${BLUE}[5] Other materials${NC} (soft, weak, iron, ceramic)\n"
    echo ""
}

get_material_choice() {
    while true; do
        printf "${BOLD}Enter material [1-5]: ${NC}"
        read -r choice
        
        case $choice in
            1) MATERIAL="99lines"; break ;;
            2) MATERIAL="Steel"; break ;;
            3) MATERIAL="aluminium"; break ;;
            4) MATERIAL="TitaniumWikipedia"; break ;;
            5) show_advanced_materials; return ;;
            *)
                print_error "Invalid choice. Please enter 1-5."
                ;;
        esac
    done
    
    print_success "Material selected: ${BOLD}${MATERIAL}${NC}"
}

show_advanced_materials() {
    echo ""
    printf "${BOLD}Advanced Materials:${NC}\n"
    echo "[6] soft - E = 0.01 GPa (compliant mechanisms)"
    echo "[7] weak - E = 0.0001 GPa (extreme flexibility)"
    echo "[8] Iron - E = 200 GPa (cast iron)"
    echo "[9] PolycrystallineRefractory - E = 3.3 GPa (ceramics)"
    echo ""
    
    while true; do
        printf "${BOLD}Enter choice [6-9]: ${NC}"
        read -r choice
        
        case $choice in
            6) MATERIAL="soft"; break ;;
            7) MATERIAL="weak"; break ;;
            8) MATERIAL="Iron"; break ;;
            9) MATERIAL="PolycrystallineRefractory"; break ;;
            *)
                print_error "Invalid choice. Please enter 6-9."
                ;;
        esac
    done
    
    print_success "Material selected: ${BOLD}${MATERIAL}${NC}"
}

# ==============================================================================
# OPTIMIZATION PARAMETERS
# ==============================================================================

show_optimization_menu() {
    print_header "OPTIMIZATION PARAMETERS"
    
    printf "${BOLD}Configure SIMP optimization settings:${NC}\n"
    echo ""
    printf "${CYAN}Volume Fraction:${NC} How much material to use\n"
    echo "  Current: ${BOLD}${VOLFRAC}${NC} ($(echo "$VOLFRAC * 100" | bc)% material, rest is void)"
    echo ""
    printf "${CYAN}SIMP Penalty (p):${NC} Solid/void sharpness\n"
    echo "  Current: ${BOLD}${SIMP_P}${NC} (3.0 = standard, higher = sharper)"
    echo ""
    printf "${CYAN}Filter Radius (rmin):${NC} Feature smoothness\n"
    echo "  Current: ${BOLD}${FILTER_RMIN}${NC} (affects minimum feature size)"
    echo ""
    printf "${GREEN}[1]${NC} Quick presets (recommended)\n"
    printf "${YELLOW}[2]${NC} Custom values (advanced)\n"
    printf "${BLUE}[3]${NC} Keep defaults and continue\n"
    echo ""
}

get_optimization_choice() {
    while true; do
        printf "${BOLD}Enter choice [1-3]: ${NC}"
        read -r choice
        
        case $choice in
            1) show_optimization_presets; return ;;
            2) get_custom_optimization_params; return ;;
            3) print_info "Using defaults"; return ;;
            *)
                print_error "Invalid choice. Please enter 1-3."
                ;;
        esac
    done
}

show_optimization_presets() {
    echo ""
    printf "${BOLD}Optimization Presets:${NC}\n"
    echo ""
    printf "${GREEN}[1] Ultra-lightweight${NC} - 10% material (artistic, may be weak)\n"
    printf "${CYAN}[2] Lightweight${NC} - 15% material (minimal design)\n"
    printf "${YELLOW}[3] Balanced${NC} ⭐ - 25% material (good strength/weight)\n"
    printf "${MAGENTA}[4] Robust${NC} - 35% material (conservative, strong)\n"
    printf "${BLUE}[5] Very solid${NC} - 50% material (approaching full material)\n"
    echo ""
    
    while true; do
        printf "${BOLD}Select preset [1-5]: ${NC}"
        read -r preset
        
        case $preset in
            1) VOLFRAC=0.10; SIMP_P=3.0; FILTER_RMIN=0.05; break ;;
            2) VOLFRAC=0.15; SIMP_P=3.0; FILTER_RMIN=0.05; break ;;
            3) VOLFRAC=0.25; SIMP_P=3.0; FILTER_RMIN=0.05; break ;;
            4) VOLFRAC=0.35; SIMP_P=3.0; FILTER_RMIN=0.06; break ;;
            5) VOLFRAC=0.50; SIMP_P=3.0; FILTER_RMIN=0.08; break ;;
            *)
                print_error "Invalid choice. Please enter 1-5."
                ;;
        esac
    done
    
    print_success "Preset applied: ${BOLD}${VOLFRAC}${NC} volume fraction"
}

get_custom_optimization_params() {
    echo ""
    
    # Volume fraction
    while true; do
        printf "${BOLD}Enter volume fraction (0.05-0.70): ${NC}"
        read -r vf_input
        if [[ "$vf_input" =~ ^[0-9]+\.?[0-9]*$ ]] && \
           (( $(echo "$vf_input >= 0.05" | bc -l) )) && \
           (( $(echo "$vf_input <= 0.70" | bc -l) )); then
            VOLFRAC=$vf_input
            break
        else
            print_error "Please enter a number between 0.05 and 0.70"
        fi
    done
    
    # SIMP penalty
    while true; do
        printf "${BOLD}Enter SIMP penalty (1.5-5.0, default 3.0): ${NC}"
        read -r p_input
        if [ -z "$p_input" ]; then
            SIMP_P=3.0
            break
        elif [[ "$p_input" =~ ^[0-9]+\.?[0-9]*$ ]] && \
             (( $(echo "$p_input >= 1.5" | bc -l) )) && \
             (( $(echo "$p_input <= 5.0" | bc -l) )); then
            SIMP_P=$p_input
            break
        else
            print_error "Please enter a number between 1.5 and 5.0 (or press Enter for default)"
        fi
    done
    
    # Filter radius
    while true; do
        printf "${BOLD}Enter filter radius (0.02-0.15, default 0.05): ${NC}"
        read -r rmin_input
        if [ -z "$rmin_input" ]; then
            FILTER_RMIN=0.05
            break
        elif [[ "$rmin_input" =~ ^[0-9]+\.?[0-9]*$ ]] && \
             (( $(echo "$rmin_input >= 0.02" | bc -l) )) && \
             (( $(echo "$rmin_input <= 0.15" | bc -l) )); then
            FILTER_RMIN=$rmin_input
            break
        else
            print_error "Please enter a number between 0.02 and 0.15 (or press Enter for default)"
        fi
    done
    
    print_success "Custom parameters set: volfrac=${VOLFRAC}, p=${SIMP_P}, rmin=${FILTER_RMIN}"
}

# ==============================================================================
# SOLVER SELECTION
# ==============================================================================

show_solver_menu() {
    print_header "LINEAR SOLVER SELECTION"
    
    printf "${BOLD}Available Solvers:${NC}\n"
    echo ""
    printf "${GREEN}[1] CHOLMOD${NC} ⭐ (Recommended)\n"
    echo "    Type: Direct solver"
    echo "    Speed: ⚡⚡⚡ Fast (~45 sec/iteration)"
    echo "    Memory: 📊 ~1.5 GB"
    echo "    Status: ✅ Available"
    echo ""
    printf "${YELLOW}[2] DirectLDL${NC}\n"
    echo "    Type: Direct solver"
    echo "    Speed: ⚡⚡ Medium (~60 sec/iteration)"
    echo "    Memory: 📊 ~1.0 GB"
    echo "    Status: ⚠️  May be available"
    echo ""
    printf "${CYAN}[3] CG${NC} (Conjugate Gradient)\n"
    echo "    Type: Iterative solver"
    echo "    Speed: ⚡ Slower (~90 sec/iteration)"
    echo "    Memory: 📊 ~300 MB (memory efficient)"
    echo "    Status: ⚠️  May be available"
    echo ""
    print_warning "PARDISO and LIS are not available in your openCFS build"
    echo ""
}

get_solver_choice() {
    while true; do
        printf "${BOLD}Select solver [1-3]: ${NC}"
        read -r choice
        
        case $choice in
            1) 
                SOLVER="cholmod"
                SOLVER_NAME="CHOLMOD"
                break
                ;;
            2) 
                SOLVER="directLDL"
                SOLVER_NAME="DirectLDL"
                break
                ;;
            3) 
                SOLVER="cg"
                SOLVER_NAME="CG"
                break
                ;;
            *)
                print_error "Invalid choice. Please enter 1, 2, or 3."
                ;;
        esac
    done
    
    print_success "Solver selected: ${BOLD}${SOLVER_NAME}${NC}"
}

# ==============================================================================
# CONFIGURATION SUMMARY
# ==============================================================================

show_configuration_summary() {
    print_header "CONFIGURATION SUMMARY"
    
    printf "${BOLD}Your optimization will run with:${NC}\n"
    echo ""
    printf "${CYAN}Mesh:${NC}\n"
    echo "  └─ Resolution: ${BOLD}${NX}×${NY}×${NZ}${NC} = $((NX*NY*NZ)) elements"
    echo "  └─ Preset: ${MESH_PRESET}"
    echo ""
    printf "${CYAN}Material:${NC}\n"
    echo "  └─ Type: ${BOLD}${MATERIAL}${NC}"
    echo ""
    printf "${CYAN}Optimization:${NC}\n"
    echo "  └─ Volume fraction: ${BOLD}${VOLFRAC}${NC} ($(echo "$VOLFRAC * 100" | bc)% material)"
    echo "  └─ SIMP penalty: ${BOLD}${SIMP_P}${NC}"
    echo "  └─ Filter radius: ${BOLD}${FILTER_RMIN}${NC}"
    echo ""
    printf "${CYAN}Solver:${NC}\n"
    echo "  └─ ${BOLD}${SOLVER_NAME}${NC}"
    echo ""
    
    # Estimate runtime
    local iterations=50
    local time_per_iter=45
    if [ "$SOLVER" = "directLDL" ]; then time_per_iter=60; fi
    if [ "$SOLVER" = "cg" ]; then time_per_iter=90; fi
    
    # Scale by mesh size
    local mesh_factor=$(echo "scale=2; $((NX*NY*NZ)) / 60000" | bc)
    local est_time=$(echo "scale=0; $iterations * $time_per_iter * $mesh_factor / 60" | bc)
    
    printf "${YELLOW}Estimated runtime:${NC} ~${est_time} minutes (${iterations} iterations)\n"
    echo ""
}

confirm_and_run() {
    while true; do
        printf "${BOLD}Proceed with this configuration? [Y/n]: ${NC}"
        read -r confirm
        confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
        
        if [[ -z "$confirm" || "$confirm" == "y" || "$confirm" == "yes" ]]; then
            return 0
        elif [[ "$confirm" == "n" || "$confirm" == "no" ]]; then
            print_info "Configuration cancelled. Returning to main menu..."
            return 1
        else
            print_error "Please enter Y or N"
        fi
    done
}

# ==============================================================================
# PARAMETER STUDY MODE
# ==============================================================================

show_parameter_study_menu() {
    print_header "PARAMETER STUDY MODE"
    
    printf "${BOLD}Select parameter to vary:${NC}\n"
    echo ""
    printf "${GREEN}[1] Volume Fraction Study${NC}\n"
    echo "    Test: 10%, 15%, 20%, 25%, 30%, 35%"
    echo "    Compare: weight vs. compliance"
    echo ""
    printf "${CYAN}[2] Material Comparison${NC}\n"
    echo "    Test: 99lines, Steel, Aluminium, Titanium"
    echo "    Compare: final topologies"
    echo ""
    printf "${YELLOW}[3] Mesh Convergence Study${NC}\n"
    echo "    Test: Coarse, Medium, Fine meshes"
    echo "    Verify: mesh independence"
    echo ""
    printf "${MAGENTA}[4] Filter Radius Study${NC}\n"
    echo "    Test: rmin = 0.03, 0.05, 0.08, 0.12"
    echo "    Compare: feature sizes"
    echo ""
    printf "${BLUE}[B] Back to main menu${NC}\n"
    echo ""
}

run_parameter_study() {
    show_parameter_study_menu
    
    while true; do
        printf "${BOLD}Select study [1-4/B]: ${NC}"
        read -r choice
        choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')
        
        case $choice in
            1) run_volume_fraction_study; return ;;
            2) run_material_comparison_study; return ;;
            3) run_mesh_convergence_study; return ;;
            4) run_filter_radius_study; return ;;
            B) return ;;
            *)
                print_error "Invalid choice. Please enter 1-4 or B."
                ;;
        esac
    done
}

run_volume_fraction_study() {
    print_header "VOLUME FRACTION PARAMETER STUDY"
    
    local vf_values=(0.10 0.15 0.20 0.25 0.30 0.35)
    local study_dir="$RESULTS_DIR/study_volfrac_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$study_dir"
    
    print_info "Running ${#vf_values[@]} optimizations with different volume fractions..."
    print_info "Results will be saved in: ${study_dir##*/}"
    echo ""
    
    # Fix other parameters
    MESH_PRESET="medium"
    NX=50; NY=40; NZ=30
    MATERIAL="99lines"
    SIMP_P=3.0
    FILTER_RMIN=0.05
    SOLVER="cholmod"
    SOLVER_NAME="CHOLMOD"
    
    for vf in "${vf_values[@]}"; do
        VOLFRAC=$vf
        print_step "Running optimization with volfrac = ${vf}..."
        
        # Update parameters and run
        update_mesh_in_python
        update_xml_parameters
        run_mesh_generation
        run_optimization
        
        # Move results to study directory
        local run_dir="$study_dir/volfrac_${vf}"
        mkdir -p "$run_dir"
        cp -r "$OUTPUTS_DIR"/* "$run_dir/" 2>/dev/null || true
        
        print_success "Completed: volfrac = ${vf}"
        echo ""
    done
    
    generate_study_report "$study_dir" "volume_fraction"
    print_success "Parameter study complete! Results in: ${study_dir}"
}

run_material_comparison_study() {
    print_header "MATERIAL COMPARISON STUDY"
    
    local materials=("99lines" "Steel" "aluminium" "TitaniumWikipedia")
    local study_dir="$RESULTS_DIR/study_materials_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$study_dir"
    
    print_info "Running ${#materials[@]} optimizations with different materials..."
    echo ""
    
    # Fix other parameters
    MESH_PRESET="medium"
    NX=50; NY=40; NZ=30
    VOLFRAC=0.25
    SIMP_P=3.0
    FILTER_RMIN=0.05
    SOLVER="cholmod"
    
    for mat in "${materials[@]}"; do
        MATERIAL=$mat
        print_step "Running optimization with material = ${mat}..."
        
        update_mesh_in_python
        update_xml_parameters
        run_mesh_generation
        run_optimization
        
        local run_dir="$study_dir/material_${mat}"
        mkdir -p "$run_dir"
        cp -r "$OUTPUTS_DIR"/* "$run_dir/" 2>/dev/null || true
        
        print_success "Completed: material = ${mat}"
        echo ""
    done
    
    generate_study_report "$study_dir" "material"
    print_success "Material comparison complete! Results in: ${study_dir}"
}

run_mesh_convergence_study() {
    print_header "MESH CONVERGENCE STUDY"
    
    local mesh_configs=("40,32,24" "50,40,30" "80,64,48" "100,80,60")
    local study_dir="$RESULTS_DIR/study_mesh_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$study_dir"
    
    print_info "Running ${#mesh_configs[@]} optimizations with different mesh densities..."
    echo ""
    
    # Fix other parameters
    MATERIAL="99lines"
    VOLFRAC=0.25
    SIMP_P=3.0
    FILTER_RMIN=0.05
    SOLVER="cholmod"
    
    for config in "${mesh_configs[@]}"; do
        IFS=',' read -r nx ny nz <<< "$config"
        NX=$nx; NY=$ny; NZ=$nz
        print_step "Running optimization with mesh = ${NX}×${NY}×${NZ}..."
        
        update_mesh_in_python
        update_xml_parameters
        run_mesh_generation
        run_optimization
        
        local run_dir="$study_dir/mesh_${NX}x${NY}x${NZ}"
        mkdir -p "$run_dir"
        cp -r "$OUTPUTS_DIR"/* "$run_dir/" 2>/dev/null || true
        
        print_success "Completed: mesh = ${NX}×${NY}×${NZ}"
        echo ""
    done
    
    generate_study_report "$study_dir" "mesh_convergence"
    print_success "Mesh convergence study complete! Results in: ${study_dir}"
}

run_filter_radius_study() {
    print_header "FILTER RADIUS STUDY"
    
    local rmin_values=(0.03 0.05 0.08 0.12)
    local study_dir="$RESULTS_DIR/study_rmin_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$study_dir"
    
    print_info "Running ${#rmin_values[@]} optimizations with different filter radii..."
    echo ""
    
    # Fix other parameters
    MESH_PRESET="medium"
    NX=50; NY=40; NZ=30
    MATERIAL="99lines"
    VOLFRAC=0.25
    SIMP_P=3.0
    SOLVER="cholmod"
    
    for rmin in "${rmin_values[@]}"; do
        FILTER_RMIN=$rmin
        print_step "Running optimization with rmin = ${rmin}..."
        
        update_mesh_in_python
        update_xml_parameters
        run_mesh_generation
        run_optimization
        
        local run_dir="$study_dir/rmin_${rmin}"
        mkdir -p "$run_dir"
        cp -r "$OUTPUTS_DIR"/* "$run_dir/" 2>/dev/null || true
        
        print_success "Completed: rmin = ${rmin}"
        echo ""
    done
    
    generate_study_report "$study_dir" "filter_radius"
    print_success "Filter radius study complete! Results in: ${study_dir}"
}

generate_study_report() {
    local study_dir="$1"
    local study_type="$2"
    
    local report_file="$study_dir/STUDY_REPORT.md"
    
    cat > "$report_file" << EOF
# Parameter Study Report: ${study_type}

**Date**: $(date)
**Study Directory**: ${study_dir}

## Configuration

- Study Type: ${study_type}
- Base Mesh: ${NX}×${NY}×${NZ}
- Material: ${MATERIAL}
- Solver: ${SOLVER_NAME}

## Results

EOF
    
    # List all run directories
    echo "### Completed Runs" >> "$report_file"
    echo "" >> "$report_file"
    for run_dir in "$study_dir"/*/; do
        if [ -d "$run_dir" ]; then
            local run_name=$(basename "$run_dir")
            echo "- ${run_name}" >> "$report_file"
        fi
    done
    
    echo "" >> "$report_file"
    echo "## Analysis" >> "$report_file"
    echo "" >> "$report_file"
    echo "To compare results:" >> "$report_file"
    echo "1. Open each .vtk file in ParaView" >> "$report_file"
    echo "2. Compare final compliance values (in solver output)" >> "$report_file"
    echo "3. Visualize differences in topology" >> "$report_file"
    echo "" >> "$report_file"
    echo "## Next Steps" >> "$report_file"
    echo "" >> "$report_file"
    echo "- Plot compliance vs. parameter" >> "$report_file"
    echo "- Identify optimal configuration" >> "$report_file"
    echo "- Run final high-resolution optimization" >> "$report_file"
    
    print_success "Study report generated: ${report_file}"
}

# ==============================================================================
# CORE EXECUTION FUNCTIONS
# ==============================================================================

update_mesh_in_python() {
    print_step "Updating mesh parameters in TvSupport.py..."
    
    # Update NX, NY, NZ in Python file
    sed -i.bak "s/^NX = [0-9]*/NX = $NX/" "$PROJECT_ROOT/TvSupport.py"
    sed -i.bak "s/^NY = int.*/NY = $NY/" "$PROJECT_ROOT/TvSupport.py"
    sed -i.bak "s/^NZ = int.*/NZ = $NZ/" "$PROJECT_ROOT/TvSupport.py"
    
    rm -f "$PROJECT_ROOT/TvSupport.py.bak"
    
    print_success "Mesh parameters updated: ${NX}×${NY}×${NZ}"
}

update_xml_parameters() {
    print_step "Updating optimization parameters in TvSupport.xml..."
    
    local xml_file="$PROJECT_ROOT/TvSupport.xml"
    local temp_file="${xml_file}_temp"
    
    # Create temp file with absolute path to mat.xml
    sed "s|file=\"mat.xml\"|file=\"$PROJECT_ROOT/mat.xml\"|g" "$xml_file" > "$temp_file"
    
    # Update material
    sed -i.bak "s|material=\"[^\"]*\"|material=\"$MATERIAL\"|g" "$temp_file"
    
    # Update volfrac
    sed -i.bak "s|<volfrac>[0-9.]*</volfrac>|<volfrac>$VOLFRAC</volfrac>|g" "$temp_file"
    
    # Update SIMP penalty
    sed -i.bak "s|<p>[0-9.]*</p>|<p>$SIMP_P</p>|g" "$temp_file"
    
    # Update filter radius
    sed -i.bak "s|<rmin>[0-9.]*</rmin>|<rmin>$FILTER_RMIN</rmin>|g" "$temp_file"
    
    # Update solver
    sed -i.bak "s|<cholmod/>|<${SOLVER}/>|g" "$temp_file"
    sed -i.bak "s|<pardiso/>|<${SOLVER}/>|g" "$temp_file"
    sed -i.bak "s|<directLDL/>|<${SOLVER}/>|g" "$temp_file"
    sed -i.bak "s|<cg/>|<${SOLVER}/>|g" "$temp_file"
    sed -i.bak "s|<lis/>|<${SOLVER}/>|g" "$temp_file"
    
    rm -f "${temp_file}.bak"
    
    print_success "XML parameters updated"
}

run_mesh_generation() {
    print_header "MESH GENERATION"
    
    print_step "Generating mesh with Python..."
    echo ""
    
    cd "$PROJECT_ROOT"
    python3 TvSupport.py
    
    echo ""
    print_success "Mesh generation complete!"
}

run_optimization() {
    print_header "RUNNING OPTIMIZATION"
    
    # Find the generated mesh file
    local mesh_file=$(ls -t "$MESHES_DIR"/*.mesh 2>/dev/null | head -1)
    
    if [ -z "$mesh_file" ]; then
        print_error "No mesh file found in $MESHES_DIR"
        exit 1
    fi
    
    print_info "Using mesh: ${mesh_file##*/}"
    print_info "Solver: ${SOLVER_NAME}"
    print_info "Material: ${MATERIAL}"
    print_info "Volume fraction: ${VOLFRAC}"
    echo ""
    
    print_step "Running openCFS optimization..."
    print_warning "This may take several minutes. Press Ctrl+C to stop."
    echo ""
    
    cd "$OUTPUTS_DIR"
    
    # Use the temp XML file with absolute paths
    local temp_xml="${PROJECT_ROOT}/TvSupport.xml_temp"
    
    # Run CFS
    cfs -m "$mesh_file" "$temp_xml" || {
        print_error "Optimization failed!"
        print_info "Check the output above for error messages"
        exit 1
    }
    
    echo ""
    print_success "Optimization complete!"
    
    # Clean up temp file
    rm -f "$temp_xml"
}

show_results_summary() {
    print_header "RESULTS SUMMARY"
    
    local latest_cfs=$(ls -t "$OUTPUTS_DIR"/*.cfs 2>/dev/null | head -1)
    
    if [ -f "$latest_cfs" ]; then
        print_success "Output files generated in: ${OUTPUTS_DIR}"
        echo ""
        printf "${BOLD}Files:${NC}\n"
        ls -lh "$OUTPUTS_DIR"/*.{cfs,vtk} 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
        echo ""
        printf "${BOLD}To visualize:${NC}\n"
        echo "  1. Open ParaView"
        echo "  2. Load: ${latest_cfs##*/}"
        echo "  3. Apply 'Threshold' filter (density > 0.5 for solid regions)"
        echo ""
    else
        print_warning "No output files found"
    fi
}

view_documentation() {
    # Temporarily disable exit-on-error for this function
    set +e
    
    clear
    print_header "CUSTOMIZATION GUIDE"
    
    local doc_file="$PROJECT_ROOT/docs/CUSTOMIZATION_GUIDE.md"
    
    if [ -f "$doc_file" ]; then
        print_info "Opening documentation... (Press 'q' to quit viewer)"
        echo ""
        sleep 1
        if command -v less &> /dev/null; then
            less "$doc_file"
        else
            cat "$doc_file" | more
        fi
        # Clear any terminal weirdness after less/more
        clear
    else
        print_error "Documentation file not found: $doc_file"
        print_info "Please check the docs/ directory"
    fi
    
    echo ""
    print_info "Returning to main menu..."
    sleep 1
    
    # Re-enable exit-on-error
    set -e
    return 0
}

# ==============================================================================
# MAIN EXECUTION
# ==============================================================================

main() {
    # Create necessary directories
    mkdir -p "$MESHES_DIR" "$OUTPUTS_DIR"
    
    while true; do
        # Disable exit-on-error for menu navigation
        set +e
        show_main_menu
        get_main_choice
        mode=$?
        set -e
        
        case $mode in
            1)  # Quick run
                set +e  # Disable for interactive portion
                print_info "Quick run mode: using default parameters"
                show_configuration_summary
                confirm_and_run
                should_run=$?
                set -e
                
                if [ $should_run -eq 0 ]; then
                    update_mesh_in_python
                    update_xml_parameters
                    run_mesh_generation
                    run_optimization
                    show_results_summary
                    
                    echo ""
                    read -p "Press Enter to return to main menu..."
                fi
                ;;
                
            2)  # Custom parameters
                set +e  # Disable for interactive menus
                show_mesh_menu
                get_mesh_choice
                echo ""
                
                show_material_menu
                get_material_choice
                echo ""
                
                show_optimization_menu
                get_optimization_choice
                echo ""
                
                show_solver_menu
                get_solver_choice
                echo ""
                
                show_configuration_summary
                confirm_and_run
                should_run=$?
                set -e
                
                if [ $should_run -eq 0 ]; then
                    update_mesh_in_python
                    update_xml_parameters
                    run_mesh_generation
                    run_optimization
                    show_results_summary
                    
                    echo ""
                    read -p "Press Enter to return to main menu..."
                fi
                ;;
                
            3)  # Parameter study
                set +e
                run_parameter_study
                set -e
                echo ""
                read -p "Press Enter to return to main menu..."
                ;;
                
            4)  # Documentation
                view_documentation
                ;;
        esac
    done
}

# Run the script
main
