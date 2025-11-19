#!/bin/bash
CORE_FILES=(
    "linked/list.asm"
    "linked/node.asm"
    "io/int.asm"
    "io/print_str.asm"
    "io/print_hex.asm"
    "mem/alloc.asm"
    "mem/free.asm"
    "mem/heap_dump.asm"
)
TEST_FILES=(
    "mem/alloc.asm"
    "mem/free.asm"
    "mem/heap_dump.asm"
)
NAME="programa"
RUN=false
BUILD_TESTS=false
[[ "$1" == "--run" || "$1" == "-r" || "$2" == "--run" || "$2" == "-r" ]] && RUN=true
[[ "$1" == "-t" || "$1" == "--test" || "$2" == "-t" || "$2" == "--test" ]] && BUILD_TESTS=true
mkdir -p out/{linked,io,mem,test/mem,test/obj/mem}
echo [Starting...]
if [ "$BUILD_TESTS" = true ]; then
    CORE_OBJ_FILES=""
    for file in "${CORE_FILES[@]}"; do
        CORE_OBJ_FILES="$CORE_OBJ_FILES out/${file%.asm}.o"
    done
    
    docker run --rm --platform linux/386 \
        -v "$(pwd):/work" -w /work \
        i386/ubuntu bash -c "
        echo [Updating...]
        apt-get update -qq && apt-get install -y -qq nasm binutils >/dev/null 2>&1
        
        mkdir -p out/{linked,io,mem,test/mem,test/obj/mem}
        
        echo [Compiling core files...]
        for file in ${CORE_FILES[@]}; do
            nasm -f elf32 src/\$file -o out/\${file%.asm}.o
        done
        
        echo [Compiling and linking tests...]
        for test in ${TEST_FILES[@]}; do
            # Put test object files in test/obj/ to avoid name collision
            nasm -f elf32 test/\$test -o out/test/obj/\${test%.asm}.o
            test_name=\$(basename \${test%.asm})
            ld -m elf_i386 $CORE_OBJ_FILES out/test/obj/\${test%.asm}.o -o out/test/\${test_name}
            echo \"  Built: out/test/\${test_name}\"
        done
    "
else
    ALL_FILES=("main.asm" "${CORE_FILES[@]}")
    OBJ_FILES=""
    for file in "${ALL_FILES[@]}"; do
        OBJ_FILES="$OBJ_FILES out/${file%.asm}.o"
    done
    
    docker run --rm --platform linux/386 \
        -v "$(pwd):/work" -w /work \
        i386/ubuntu bash -c "
        echo [Updating...]
        apt-get update -qq && apt-get install -y -qq nasm binutils >/dev/null 2>&1
        
        mkdir -p out/{linked,io,mem}
        
        echo [Compiling...]
        for file in ${ALL_FILES[@]}; do
            nasm -f elf32 src/\$file -o out/\${file%.asm}.o
        done
        echo [Linking...]
        ld -m elf_i386 $OBJ_FILES -o out/${NAME}
    "
fi
if [ $? -eq 0 ]; then
    echo "[Built]"
    if [ "$RUN" = true ]; then
        if [ "$BUILD_TESTS" = true ]; then
            echo "[Running tests...]"
            for test in "${TEST_FILES[@]}"; do
                test_name=$(basename ${test%.asm})
                echo "  Running: $test_name"
                docker run --rm --platform linux/386 \
                    -v "$(pwd)/out:/work" -w /work \
                    i386/ubuntu ./test/${test_name}
                echo ""
            done
        else
            echo "[Running...]"
            docker run --rm --platform linux/386 \
                -v "$(pwd)/out:/work" -w /work \
                i386/ubuntu ./${NAME}
        fi
    fi
else
    echo "[Failed]"
    exit 1
fi
echo "[Finished]"