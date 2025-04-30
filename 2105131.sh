cd Shell-Scripting-Assignment-Files
cd Workspace
cd submissions
files=$(ls -1 | wc -l)
echo $files


# Path for the result.csv file
result_csv="../tasks/result.csv"

# Check if the result.csv exists, create it if it doesn't, and add the header
if [ ! -f "$result_csv" ]; then
    echo "student_id,student_name,language,matched,not_matched,line_count,comment_count,function_count" > "$result_csv"
fi

# A function to add data to the CSV
add_to_csv() {
    student_id=$1
    student_name=$2
    language=$3
    matched=$4
    not_matched=$5
    line_count=$6
    comment_count=$7
    function_count=$8

    # Append the data to the CSV file
    echo "$student_id,$student_name,$language,$matched,$not_matched,$line_count,$comment_count,$function_count" >> "./tasks/result.csv"
}

# A function to extract the number of functions from the file
count_functions() {
    # Simple regex for function definitions (C/C++/Java/Python)
    grep -oP '^\s*([a-zA-Z_][a-zA-Z0-9_]*\s+)+[a-zA-Z_][a-zA-Z0-9_]*\s*\(.*\)\s*\{' "$1" | wc -l
}

unzip "*.zip"
cd .. 


#A
find_file(){
    if [ -d "$1" ]; then
        for i in "$1"/*; do
            find_file "$i"
        done 
    elif [ -f "$1" ] && [[ "$1" =~ \.c$|\.cpp$|\.java$|\.py$ ]]; then 
        echo $1
        if [[ "$1" == *_2105*.c ]]; then
            # if [[ "$1" =~ (2105[0-9]+) ]]; then
            if [[ "$1" =~ .*/([^/_]+)_[^/_]+_submission_(2105[0-9]+)/.*\.c$ ]]; then
                echo ImhereASSSWELLLL
                echo "Matched substring: ${BASH_REMATCH[0]}"
                student_name="${BASH_REMATCH[1]}"
                student_id="${BASH_REMATCH[2]}"
                new_name="main.c"
                target_dir="tasks/C/${student_id}"
                mkdir -p "$target_dir"  # make sure the directory exists
                mv "$1" "$target_dir/$new_name"
                echo "Moved and renamed: $1 → $target_dir/$new_name"
                # printLinesCommment $target_dir/$new_name
                # Get counts
                counts=$(printLinesCommment "$target_dir/$new_name")
                IFS=',' read -r line_count comment_count function_count <<< "$counts"

                # Testing
                matched=0
                not_matched=0
                runAndTest "$target_dir/$new_name"
                findDiff "$target_dir"

                # Add to CSV
                add_to_csv "$student_id" "$student_name" "C" "$matched" "$not_matched" "$line_count" "$comment_count" "$function_count"
            fi
            #echo "Matched substring: ${BASH_REMATCH[0]}"

        elif [[ "$1" == *_2105*.py ]]; then
            if [[ "$1" =~ .*/([^/_]+)_[^/_]+_submission_(2105[0-9]+)/.*\.py$ ]]; then
                echo "Matched substring: ${BASH_REMATCH[0]}"
                student_name="${BASH_REMATCH[1]}"
                student_id="${BASH_REMATCH[2]}"
                new_name="main.py"
                target_dir="tasks/Python/${student_id}"
                mkdir -p "$target_dir"  # make sure the directory exists
                mv "$1" "$target_dir/$new_name"
                echo "Moved and renamed: $1 → $target_dir/$new_name"

                counts=$(printLinesCommment "$target_dir/$new_name")
                IFS=',' read -r line_count comment_count function_count <<< "$counts"
                
                matched=0
                not_matched=0
                runAndTest "$target_dir/$new_name"
                findDiff "$target_dir"
                
                add_to_csv "$student_id" "$student_name" "Python" "$matched" "$not_matched" "$line_count" "$comment_count" "$function_count"
            fi
        elif [[ "$1" == *_2105*.cpp ]]; then
            # if [[ "$1" =~ (2105[0-9]+) ]]; then
            if [[ "$1" =~ .*/([^/_]+)_[^/_]+_submission_(2105[0-9]+)/.*\.cpp$ ]]; then
                echo "Matched substring: ${BASH_REMATCH[0]}"
                student_name="${BASH_REMATCH[1]}"
                student_id="${BASH_REMATCH[2]}"
                new_name="main.cpp"
                target_dir="tasks/C++/${student_id}"
                mkdir -p "$target_dir"  # make sure the directory exists
                mv "$1" "$target_dir/$new_name"
                echo "Moved and renamed: $1 → $target_dir/$new_name"
                # printLinesCommment $target_dir/$new_name
                # Get counts
                counts=$(printLinesCommment "$target_dir/$new_name")
                IFS=',' read -r line_count comment_count function_count <<< "$counts"

                # Testing
                matched=0
                not_matched=0
                runAndTest "$target_dir/$new_name"
                findDiff "$target_dir"

                # Add to CSV
                add_to_csv "$student_id" "$student_name" "C++" "$matched" "$not_matched" "$line_count" "$comment_count" "$function_count"
            fi
            #echo "Matched substring: ${BASH_REMATCH[0]}"

        elif [[ "$1" == *_2105*.java ]]; then
            if [[ "$1" =~ .*/([^/_]+)_[^/_]+_submission_(2105[0-9]+)/.*\.java$ ]]; then
                echo "Matched substring: ${BASH_REMATCH[0]}"
                student_name="${BASH_REMATCH[1]}"
                student_id="${BASH_REMATCH[2]}"
                new_name="Main.java"
                target_dir="tasks/java/${student_id}"
                mkdir -p "$target_dir"  # make sure the directory exists
                mv "$1" "$target_dir/$new_name"
                echo "Moved and renamed: $1 → $target_dir/$new_name"

                counts=$(printLinesCommment "$target_dir/$new_name")
                IFS=',' read -r line_count comment_count function_count <<< "$counts"
                
                matched=0
                not_matched=0
                runAndTest "$target_dir/$new_name"
                findDiff "$target_dir"
                
                add_to_csv "$student_id" "$student_name" "Java" "$matched" "$not_matched" "$line_count" "$comment_count" "$function_count"
            fi
            #echo "Matched substring: ${BASH_REMATCH[0]}"
        fi 
    fi
}


#B
printLinesCommment() {
    local file="$1"
    local lines=0
    local comments=0
    local function_count=0

    if [ -f "$file" ]; then
        if [[ "$file" =~ \.c$|\.cpp$|\.java$ ]]; then 
            lines=$(wc -l < "$file")
            comments=$(grep -c "//" "$file")
        elif [[ "$file" =~ \.py$ ]]; then
            lines=$(wc -l < "$file")
            comments=$(grep -c "#" "$file")
        fi
        function_count=$(count_functions "$file")
    fi

    echo "$lines,$comments,$function_count"
}
# printLinesCommment(){
#     local file="$1"
#     local lines=0
#     local comments=0
#     local function_count=0
#     if [ -f "$1" ] && [[ "$1" =~ \.c$|\.cpp$|\.java$ ]]; then 
#         lines=$(wc -l $1)
#         comments=$(grep "//" $1 | wc -l)
#         echo "Path: $1"
#         echo "Line Count: $lines"
#         echo "Comment Count: $comments"
#     elif [ -f "$1" ] && [[ "$1" =~ \.py$ ]]; then
#         lines=$(wc -l $1)
#         comments=$(grep "#" $1 | wc -l)
#         echo "Path: $1"
#         echo "Line Count: $lines"
#         echo "Comment Count: $comments"
#     fi 

#     function_count=$(count_functions "$file")

# }

#C

# runAndTest(){
#     if [ -f "$1" ]; then
#         dir_path=$(dirname "$1")  

#         if [[ "$1" =~ \.c$ ]]; then 
#             gcc "$1" -o "$dir_path/main.out"
#             "$dir_path/main.out" < ./tests/test1.txt > "$dir_path/out1.txt"

#         elif [[ "$1" =~ \.cpp$ ]]; then 
#             g++ "$1" -o "$dir_path/main.out"
#             "$dir_path/main.out" < ./tests/test1.txt > "$dir_path/out1.txt"

#         elif [[ "$1" =~ \.java$ ]]; then
#             javac "$1"
#             java -cp "$dir_path" Main < ./tests/test1.txt > "$dir_path/out1.txt"

#         elif [[ "$1" =~ \.py$ ]]; then
#             python3 "$1" < ./tests/test1.txt > "$dir_path/out1.txt"
#         fi
#     fi
# }

runAndTest(){
    if [ -f "$1" ]; then
        dir_path=$(dirname "$1")  

        # Check the file extension and compile/interpret accordingly
        if [[ "$1" =~ \.c$ ]]; then 
            gcc "$1" -o "$dir_path/main.out"

        elif [[ "$1" =~ \.cpp$ ]]; then 
            g++ "$1" -o "$dir_path/main.out"

        elif [[ "$1" =~ \.java$ ]]; then
            javac "$1"
        
        elif [[ "$1" =~ \.py$ ]]; then
            # No compilation for Python, just run the script
            :
        fi

        # Now loop through all test files in the tests directory
        for test_file in ./tests/test*.txt; do
            # Extract the test case number from the test file name (e.g., test1.txt -> 1)
            if [[ "$test_file" =~ test([0-9]+)\.txt ]]; then
                test_case_number="${BASH_REMATCH[1]}"  # Capture the number from the filename

                # Define the output file for each test case
                echo "Output: $test_case_number"
                output_file="$dir_path/out${test_case_number}.txt"
                
                # Run the compiled/interpreted program with the current test case input
                if [[ "$1" =~ \.c$|\.cpp$|\.java$ ]]; then
                    "$dir_path/main.out" < "$test_file" > "$output_file"
                elif [[ "$1" =~ \.py$ ]]; then
                    python3 "$1" < "$test_file" > "$output_file"
                fi
            fi
        done
    fi
}

findDiff() {
    local dir="$1"
    for output in "$dir"/out*.txt; do
        if [[ "$output" =~ out([0-9]+)\.txt ]]; then
            num="${BASH_REMATCH[1]}"
            diff "$output" "answers/ans${num}.txt" > "$dir/diff${num}.txt"
            if [ -s "$dir/diff${num}.txt" ]; then
                ((not_matched++))
            else
                ((matched++))
            fi
        fi
    done
}
# findDiff(){
#     if [ -d "$1" ]; then
#         for i in "$1"/*; do
#             findDiff "$i"
#         done
#     elif [ -f "$1" ] && [[ "$1" =~ ^out[0-9]+\.txt$ ]]; then 
#         dir_path=$(dirname "$1")
#         base_name=$(basename "$1")            # e.g., out1.txt
#         num=$(echo "$base_name" | grep -oP '\d+')  # Extracts digits like 1, 2, etc.
        
#         # Compare with corresponding answer file (e.g., ans1.txt)
#         diff "$1" "answers/ans${num}.txt" > "$dir_path/diff.txt"
        
#         # Check if the output matched
#         if [ -s "$dir_path/diff.txt" ]; then
#             # If diff.txt is not empty, outputs don't match
#             not_matched=$((not_matched + 1))
#         else
#             # If diff.txt is empty, outputs match
#             matched=$((matched + 1))
#         fi
#     fi
    
# }


# findDiff(){
#     if [ -d "$1" ]; then
#         for i in "$1"/*; do
#             findDiff "$i"
#         done 
#     elif [ -f "$1" ] && [[ "$1" =~ \.txt$ ]]; then 
#         dir_path=$(dirname "$1")
#         base_name=$(basename "$1")            # e.g., out1.txt
#         num=$(echo "$base_name" | grep -oP '\d+')  # Extracts digits like 1, 2, etc.
#         diff "$1" "answers/ans${num}.txt" > "$dir_path/diff.txt"
#         # Check if the output matched
#         if [ -s "$dir_path/diff.txt" ]; then
#             # Not matched
#             matched=0
#             not_matched=1
#         else
#             # Matched
#             matched=1
#             not_matched=0
#         fi
#     fi 
# }

find_file "./submissions"
#printLinesCommment "./tasks/C/2105228/main.c"
find ./submissions -type f ! -name '*.zip' -delete
find ./submissions -type d -empty -delete