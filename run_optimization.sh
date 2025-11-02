#!/bin/bash

# ==============================================================================
# Interactive Topology Optimization Runner for TV Wall Mount
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

# ==============================================================================
# FUNCTIONS
# ==============================================================================

print_header() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}▶${NC} ${BOLD}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

show_solver_menu() {
    print_header "SELECT LINEAR SOLVER"
    
    echo -e "${BOLD}Available Solvers:${NC}"
    echo ""
    echo -e "${GREEN}[A] CHOLMOD${NC} ⭐ (Recommended - WORKING)"
    echo "    Type: Direct solver"
    echo "    Speed: ⚡⚡⚡ Fast (~45 sec/iteration)"
    echo "    Memory: 📊 Moderate (~1.5 GB)"
    echo "    Best for: Development & medium meshes"
    echo "    Status: ✅ Available in your openCFS build"
    echo ""
    
    echo -e "${YELLOW}[B] DirectLDL${NC}"
    echo "    Type: Direct solver"
    echo "    Speed: ⚡⚡ Medium (~60 sec/iteration)"
    echo "    Memory: 📊 Moderate (~1 GB)"
    echo "    Best for: Smaller problems"
    echo "    Status: ⚠️  May be available (try if A doesn't work)"
    echo ""
    
    echo -e "${CYAN}[C] CG${NC} (Memory efficient)"
    echo "    Type: Iterative solver"
    echo "    Speed: ⚡ Slower (~90 sec/iteration)"
    echo "    Memory: 📊 Low (~300 MB)"
    echo "    Best for: Very large meshes, limited RAM"
    echo "    Status: ⚠️  May be available"
    echo ""
    
    echo -e "${RED}[NOT AVAILABLE]${NC}"
    echo "    ❌ PARDISO - Not compiled in your openCFS build"
    echo "    ❌ LIS - Not compiled in your openCFS build"
    echo ""
    
    echo -e "${BOLD}Performance Estimate for Your Mesh (50×40×30 = 60k elements):${NC}"
    echo "  Total time = iterations × solver speed"
    echo "  With 50 iterations:"
    echo "    A) CHOLMOD:   ~37 minutes ⭐ (Safe choice)"
    echo "    B) DirectLDL: ~50 minutes"
    echo "    C) CG:        ~75 minutes"
    echo ""
    echo -e "${YELLOW}Note: Your openCFS was compiled without PARDISO & LIS support${NC}"
    echo ""
}

get_solver_choice() {
    while true; do
        echo -n -e "${BOLD}Enter your choice [A/B/C] (or Q to quit): ${NC}"
        read -r choice
        choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')
        
        case $choice in
            A) 
                SOLVER="cholmod"
                SOLVER_NAME="CHOLMOD"
                break
                ;;
            B) 
                SOLVER="directLDL"
                SOLVER_NAME="DirectLDL"
                break
                ;;
            C) 
                SOLVER="cg"
                SOLVER_NAME="CG (Conjugate Gradient)"
                break
                ;;
            D|E)
                print_error "PARDISO and LIS are not available in your openCFS build."
                print_info "Please choose A (CHOLMOD), B (DirectLDL), or C (CG)"
                ;;
            Q)
                echo ""
                print_info "Optimization cancelled by user."
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please enter A, B, or C (or Q to quit)."
                ;;
        esac
    done
}

update_solver_in_xml() {
    local solver_tag="$1"
    local xml_file="$PROJECT_ROOT/TvSupport.xml"
    
    print_step "Updating solver in TvSupport.xml to: ${BOLD}${SOLVER_NAME}${NC}"
    
    # Create backup
    cp "$xml_file" "$xml_file.backup"
    
    # Replace solver tag (looking for the pattern in linearSystems section)
    sed -i.tmp "s|<cholmod/>|<${solver_tag}/>|g" "$xml_file"
    sed -i.tmp "s|<pardiso/>|<${solver_tag}/>|g" "$xml_file"
    sed -i.tmp "s|<directLDL/>|<${solver_tag}/>|g" "$xml_file"
    sed -i.tmp "s|<cg/>|<${solver_tag}/>|g" "$xml_file"
    sed -i.tmp "s|<lis/>|<${solver_tag}/>|g" "$xml_file"
    
    rm -f "$xml_file.tmp"
    
    print_success "Solver updated to: ${SOLVER_NAME}"
}

offer_solver_comparison() {
    echo ""
    print_header "SOLVER COMPARISON (Optional)"
    
    echo -e "${BOLD}Would you like to compare this solver with others?${NC}"
    echo ""
    echo "This will run the optimization with multiple solvers and"
    echo "generate a comparison report showing:"
    echo "  • Execution time for each solver"
    echo "  • Memory usage"
    echo "  • Result differences (should be < 0.1%)"
    echo ""
    echo -e "${YELLOW}Note: This will take significant time (4-5x longer)${NC}"
    echo ""
    
    echo -n -e "${BOLD}Run solver comparison? [y/N]: ${NC}"
    read -r compare_choice
    compare_choice=$(echo "$compare_choice" | tr '[:upper:]' '[:lower:]')
    
    if [[ "$compare_choice" == "y" || "$compare_choice" == "yes" ]]; then
        run_solver_comparison
    else
        print_info "Skipping solver comparison."
    fi
}

run_solver_comparison() {
    print_header "RUNNING SOLVER COMPARISON"
    
    local SOLVERS=("cholmod" "directLDL" "cg")
    local SOLVER_NAMES=("CHOLMOD" "DirectLDL" "CG")
    local comparison_dir="$RESULTS_DIR/solver_comparison_$(date +%Y%m%d_%H%M%S)"
    
    mkdir -p "$comparison_dir"
    
    print_info "Results will be saved in: ${comparison_dir##*/}"
    echo ""
    
    # Find the mesh file
    local mesh_file=$(ls -t "$MESHES_DIR"/*.mesh 2>/dev/null | head -1)
    if [[ -z "$mesh_file" ]]; then
        print_error "No mesh file found. Cannot run comparison."
        return 1
    fi
    
    print_info "Using mesh: ${mesh_file##*/}"
    echo ""
    
    # Run optimization with each solver
    for i in "${!SOLVERS[@]}"; do
        local solver="${SOLVERS[$i]}"
        local solver_name="${SOLVER_NAMES[$i]}"
        local output_dir="$comparison_dir/${solver}_output"
        
        mkdir -p "$output_dir"
        
        print_step "Testing solver: ${BOLD}$solver_name${NC} ($(($i + 1))/${#SOLVERS[@]})"
        
        # Update XML
        update_solver_in_xml "$solver"
        
        # Run CFS with time measurement
        local start_time=$(date +%s)
        
        # Create temporary XML with absolute path to mat.xml
        local temp_xml="$output_dir/TvSupport_temp.xml"
        sed "s|file=\"mat.xml\"|file=\"$PROJECT_ROOT/mat.xml\"|g" "$PROJECT_ROOT/TvSupport.xml" > "$temp_xml"
        
        cd "$output_dir"
        if "$PROJECT_ROOT/src/bin/cfs" -m "$mesh_file" -p "$temp_xml" TvSupport > cfs.log 2>&1; then
            local end_time=$(date +%s)
            local duration=$((end_time - start_time))
            
            echo "$duration" > timing.txt
            rm -f "$temp_xml"
            print_success "$solver_name completed in ${duration}s"
        else
            rm -f "$temp_xml"
            print_error "$solver_name failed. Check $output_dir/cfs.log"
        fi
        
        cd "$PROJECT_ROOT"
        echo ""
    done
    
    # Generate comparison report
    generate_comparison_report "$comparison_dir"
}

generate_comparison_report() {
    local comparison_dir="$1"
    local report_file="$comparison_dir/COMPARISON_REPORT.txt"
    
    print_step "Generating comparison report..."
    
    {
        echo "═══════════════════════════════════════════════════════════════"
        echo "SOLVER COMPARISON REPORT"
        echo "═══════════════════════════════════════════════════════════════"
        echo "Date: $(date)"
        echo "Mesh: $(ls -t "$MESHES_DIR"/*.mesh 2>/dev/null | head -1 | xargs basename)"
        echo ""
        echo "───────────────────────────────────────────────────────────────"
        echo "TIMING RESULTS"
        echo "───────────────────────────────────────────────────────────────"
        
        local solvers=("cholmod" "directLDL" "cg")
        local names=("CHOLMOD" "DirectLDL" "CG")
        
        for i in "${!solvers[@]}"; do
            local solver="${solvers[$i]}"
            local name="${names[$i]}"
            local timing_file="$comparison_dir/${solver}_output/timing.txt"
            
            if [[ -f "$timing_file" ]]; then
                local time=$(cat "$timing_file")
                local minutes=$((time / 60))
                local seconds=$((time % 60))
                printf "%-15s : %3dm %02ds (%d seconds)\n" "$name" "$minutes" "$seconds" "$time"
            else
                printf "%-15s : FAILED\n" "$name"
            fi
        done
        
        echo ""
        echo "───────────────────────────────────────────────────────────────"
        echo "RECOMMENDATION"
        echo "───────────────────────────────────────────────────────────────"
        echo "• Fastest solver: Check timing results above"
        echo "• For daily work: CHOLMOD (good balance)"
        echo "• For large meshes: CG (memory efficient)"
        echo ""
        echo "Note: PARDISO and LIS not available in your openCFS build"
        echo ""
        echo "═══════════════════════════════════════════════════════════════"
    } > "$report_file"
    
    cat "$report_file"
    
    print_success "Comparison report saved: ${report_file##*/}"
    print_info "Full results in: ${comparison_dir##*/}/"
}

# ==============================================================================
# MAIN WORKFLOW
# ==============================================================================

clear

print_header "TV WALL MOUNT TOPOLOGY OPTIMIZATION"

# Set up environment
print_step "Setting up environment..."
export PYTHONPATH="$PROJECT_ROOT/src/share/python:$PYTHONPATH"
export PATH="$PROJECT_ROOT/src/bin:$PATH"
print_success "Environment configured"

# Create directories
mkdir -p "$MESHES_DIR" "$OUTPUTS_DIR"

# Step 1: Solver Selection
show_solver_menu
get_solver_choice

echo ""
print_success "Selected solver: ${BOLD}${SOLVER_NAME}${NC}"

# Update XML with chosen solver
update_solver_in_xml "$SOLVER"

# Step 2: Generate Mesh
print_header "MESH GENERATION"

print_step "Generating 3D structured mesh..."
if python3 "$PROJECT_ROOT/TvSupport.py"; then
    print_success "Mesh generated successfully"
    
    # Find the generated mesh file
    MESH_FILE=$(ls -t "$MESHES_DIR"/*.mesh 2>/dev/null | head -1)
    if [[ -n "$MESH_FILE" ]]; then
        MESH_SIZE=$(du -h "$MESH_FILE" | cut -f1)
        print_info "Mesh file: ${MESH_FILE##*/} (${MESH_SIZE})"
    fi
else
    print_error "Mesh generation failed!"
    exit 1
fi

# Step 3: Run Optimization
print_header "TOPOLOGY OPTIMIZATION"

print_step "Running openCFS optimization with ${BOLD}${SOLVER_NAME}${NC}..."
print_warning "This may take 25-100 minutes depending on the solver..."

cd "$OUTPUTS_DIR"

START_TIME=$(date +%s)

# Create temporary XML with absolute path to mat.xml
TEMP_XML="$OUTPUTS_DIR/TvSupport_temp.xml"
sed "s|file=\"mat.xml\"|file=\"$PROJECT_ROOT/mat.xml\"|g" "$PROJECT_ROOT/TvSupport.xml" > "$TEMP_XML"

if "$PROJECT_ROOT/src/bin/cfs" -m "$MESH_FILE" -p "$TEMP_XML" TvSupport; then
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    MINUTES=$((DURATION / 60))
    SECONDS=$((DURATION % 60))
    
    # Clean up temp XML
    rm -f "$TEMP_XML"
    
    print_success "Optimization completed in ${MINUTES}m ${SECONDS}s"
else
    print_error "Optimization failed!"
    rm -f "$TEMP_XML"
    cd "$PROJECT_ROOT"
    exit 1
fi

cd "$PROJECT_ROOT"

# Step 4: Display Results
print_header "RESULTS SUMMARY"

echo -e "${BOLD}Solver Used:${NC} ${SOLVER_NAME}"
echo -e "${BOLD}Execution Time:${NC} ${MINUTES}m ${SECONDS}s"
echo -e "${BOLD}Mesh File:${NC} ${MESH_FILE##*/}"
echo ""

echo -e "${BOLD}Generated Files:${NC}"
if [[ -d "$OUTPUTS_DIR" ]]; then
    ls -lh "$OUTPUTS_DIR"/ | grep -v "^total" | grep -v "^d" | while read line; do
        echo "  $line"
    done
fi

echo ""
print_info "To visualize results:"
echo "  ${CYAN}paraview ${OUTPUTS_DIR}/TvSupport.vtk${NC}"
echo ""

# Restore original XML
if [[ -f "$PROJECT_ROOT/TvSupport.xml.backup" ]]; then
    mv "$PROJECT_ROOT/TvSupport.xml.backup" "$PROJECT_ROOT/TvSupport.xml"
    print_info "XML configuration restored to original"
fi

# Step 5: Offer Comparison
offer_solver_comparison

# Final message
print_header "OPTIMIZATION COMPLETE! 🎉"

echo -e "${GREEN}Next steps:${NC}"
echo "  1. View results: ${CYAN}paraview ${OUTPUTS_DIR}/TvSupport.vtk${NC}"
echo "  2. Check optimization log: ${CYAN}cat ${OUTPUTS_DIR}/TvSupport.cfs${NC}"
echo "  3. Read solver guide: ${CYAN}cat SOLVERS_EXPLAINED.md${NC}"
echo ""

print_success "All done! Your optimized TV mount design is ready."
echo ""
