cd Shell-Scripting-Assignment-Files
cd Workspace
cd submissions
files=$(ls -1 | wc -l)
echo $files



unzip "*.zip"
cd .. 


#A
find_file(){
    if [ -d "$1" ]; then
        for i in "$1"/*; do
            find_file "$i"
        done 
    elif [ -f "$1" ] && [[ "$1" =~ \.c$|\.cpp$|\.java$|\.py$ ]]; then 
        if [[ "$1" == *_2105*.c ]]; then
            if [[ "$1" =~ (2105[0-9]+) ]]; then
                echo "Matched substring: ${BASH_REMATCH[0]}"
                new_name="main.c"
                target_dir="tasks/C/${BASH_REMATCH[0]}"
                mkdir -p "$target_dir"  # make sure the directory exists
                mv "$1" "$target_dir/$new_name"
                echo "Moved and renamed: $1 → $target_dir/$new_name"
                printLinesCommment $target_dir/$new_name
                runAndTest $target_dir/$new_name
            fi
            #echo "Matched substring: ${BASH_REMATCH[0]}"

        elif [[ "$1" == *_2105*.py ]]; then
            if [[ "$1" =~ (2105[0-9]+) ]]; then
                echo "Matched substring: ${BASH_REMATCH[0]}"
                new_name="main.py"
                target_dir="tasks/Python/${BASH_REMATCH[0]}"
                mkdir -p "$target_dir"  # make sure the directory exists
                mv "$1" "$target_dir/$new_name"
                echo "Moved and renamed: $1 → $target_dir/$new_name"
                printLinesCommment $target_dir/$new_name
                runAndTest $target_dir/$new_name
            fi

        elif [[ "$1" == *_2105*.cpp ]]; then
            if [[ "$1" =~ (2105[0-9]+) ]]; then
                echo "Matched substring: ${BASH_REMATCH[0]}"
                new_name="main.cpp"
                target_dir="tasks/C++/${BASH_REMATCH[0]}"
                mkdir -p "$target_dir"  # make sure the directory exists
                mv "$1" "$target_dir/$new_name"
                echo "Moved and renamed: $1 → $target_dir/$new_name"
                printLinesCommment $target_dir/$new_name
                runAndTest $target_dir/$new_name
            fi

        elif [[ "$1" == *_2105*.java ]]; then
            if [[ "$1" =~ (2105[0-9]+) ]]; then
                echo "Matched substring: ${BASH_REMATCH[0]}"
                new_name="Main.java"
                target_dir="tasks/java/${BASH_REMATCH[0]}"
                mkdir -p "$target_dir"  # make sure the directory exists
                mv "$1" "$target_dir/$new_name"
                echo "Moved and renamed: $1 → $target_dir/$new_name"
                printLinesCommment $target_dir/$new_name
                runAndTest $target_dir/$new_name
            fi
            #echo "Matched substring: ${BASH_REMATCH[0]}"
        fi 
    fi
}


#B

printLinesCommment(){
    if [ -f "$1" ] && [[ "$1" =~ \.c$|\.cpp$|\.java$ ]]; then 
        lines=$(wc -l $1)
        comments=$(grep "//" $1 | wc -l)
        echo "Path: $1"
        echo "Line Count: $lines"
        echo "Comment Count: $comments"
    elif [ -f "$1" ] && [[ "$1" =~ \.py$ ]]; then
        lines=$(wc -l $1)
        comments=$(grep "#" $1 | wc -l)
        echo "Path: $1"
        echo "Line Count: $lines"
        echo "Comment Count: $comments"
    fi 

}

runAndTest(){
    if [ -f "$1" ]; then
        dir_path=$(dirname "$1")  

        if [[ "$1" =~ \.c$ ]]; then 
            gcc "$1" -o "$dir_path/main.out"
            "$dir_path/main.out" < ./tests/test1.txt > "$dir_path/out1.txt"

        elif [[ "$1" =~ \.cpp$ ]]; then 
            g++ "$1" -o "$dir_path/main.out"
            "$dir_path/main.out" < ./tests/test1.txt > "$dir_path/out1.txt"

        elif [[ "$1" =~ \.java$ ]]; then
            javac "$1"
            java -cp "$dir_path" Main < ./tests/test1.txt > "$dir_path/out1.txt"

        elif [[ "$1" =~ \.py$ ]]; then
            python3 "$1" < ./tests/test1.txt > "$dir_path/out1.txt"
        fi
    fi
}


find_file "./submissions"
#printLinesCommment "./tasks/C/2105228/main.c"
find ./submissions -type f ! -name '*.zip' -delete
find ./submissions -type d -empty -delete