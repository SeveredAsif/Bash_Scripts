#!/bin/bash

# Navigate to submissions directory
cd Shell-Scripting-Assignment-Files/Workspace/submissions || exit

# Configure paths relative to script location
base_dir="$(pwd)/../"
result_csv="$base_dir/tasks/result.csv"
tests_dir="$base_dir/tests"
answers_dir="$base_dir/answers"

# Create CSV header
echo "student_id,student_name,language,matched,not_matched,line_count,comment_count,function_count" > "$result_csv"

# CSV writing function
add_to_csv() {
    echo "$1,$2,$3,$4,$5,$6,$7,$8" >> "$result_csv"
}

# Improved function counter
count_functions() {
    case $1 in
        *.c|*.cpp)
            grep -cE '^[a-zA-Z_][a-zA-Z0-9_*[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*\([^)]*\)[[:space:]]*\{' "$1" ;;
        *.java)
            grep -cE '^(public|private|static)[[:space:]]+[a-zA-Z_<>][a-zA-Z0-9_<>]*([[:space:]]+)+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*\([^)]*\)' "$1" ;;
        *.py)
            grep -cE '^[[:space:]]*def[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*\(' "$1" ;;
    esac
}

# Processing functions
print_lines_comments() {
    local file=$1
    local lines comments
    lines=$(wc -l < "$file")
    
    case $file in
        *.c|*.cpp|*.java)
            comments=$(grep -c '//' "$file") ;;
        *.py)
            comments=$(grep -c '#' "$file") ;;
    esac
    
    echo "$lines,$comments"
}

find_diff() {
    local dir=$1
    local matched=0
    local not_matched=0
    
    for out_file in "$dir"/out*.txt; do
        if [[ $out_file =~ out([0-9]+).txt ]]; then
            local test_num=${BASH_REMATCH[1]}
            diff "$out_file" "$answers_dir/ans$test_num.txt" > "$dir/diff$test_num.txt"
            
            if [ -s "$dir/diff$test_num.txt" ]; then
                ((not_matched++))
            else 
                ((matched++))
            fi
        fi
    done
    
    echo "$matched,$not_matched"
}

process_file() {
    local file=$1
    [[ $file =~ ([^_]+)_(2105[0-9]+)_.*\.(c|cpp|java|py)$ ]] || return
    
    local student_name=${BASH_REMATCH[1]}
    local student_id=${BASH_REMATCH[2]}
    local lang=${BASH_REMATCH[3]}
    local target_dir="$base_dir/tasks/${lang^^}/$student_id"
    
    mkdir -p "$target_dir"
    mv "$file" "$target_dir/main.$lang"
    
    # Get file metrics
    IFS=, read -r lines comments <<< "$(print_lines_comments "$target_dir/main.$lang")"
    local functions=$(count_functions "$target_dir/main.$lang")
    
    # Compile if needed
    case $lang in
        c)
            gcc "$target_dir/main.c" -o "$target_dir/main.out" || return
            ;;
        cpp)
            g++ "$target_dir/main.cpp" -o "$target_dir/main.out" || return
            ;;
        java)
            javac "$target_dir/Main.java" -d "$target_dir" || return
            ;;
    esac
    
    # Run tests
    for test in "$tests_dir"/test*.txt; do
        [[ $test =~ test([0-9]+).txt ]] || continue
        local test_num=${BASH_REMATCH[1]}
        
        case $lang in
            c|cpp)
                "$target_dir/main.out" < "$test" > "$target_dir/out$test_num.txt"
                ;;
            java)
                java -cp "$target_dir" Main < "$test" > "$target_dir/out$test_num.txt"
                ;;
            py)
                python3 "$target_dir/main.py" < "$test" > "$target_dir/out$test_num.txt"
                ;;
        esac
    done
    
    # Get test results
    IFS=, read -r matched not_matched <<< "$(find_diff "$target_dir")"
    
    # Add to CSV
    add_to_csv "$student_id" "$student_name" "${lang^^}" "$matched" "$not_matched" "$lines" "$comments" "$functions"
}

# Main execution
unzip -q "*.zip" -d extracted
find extracted -type f \( -iname "*.c" -o -iname "*.cpp" -o -iname "*.java" -o -iname "*.py" \) | while read -r file; do
    process_file "$file"
done

# Cleanup
rm -rf extracted
find . -type f ! -name '*.zip' -delete

./2105131.sh ./Shell-Scripting-Assignment-Files/Workspace/submissions ./Shell-Scripting-Assignment-Files/Workspace/tasks ./Shell-Scripting-Assignment-Files/Workspace/tests ./Shell-Scripting-Assignment-Files/Workspace/answers

