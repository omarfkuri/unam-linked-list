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

if [ "$BUILD_TESTS" = true ]; then
    echo "[Compiling core files...]"
    CORE_OBJ_FILES=""
    for file in "${CORE_FILES[@]}"; do
        nasm -f elf32 src/$file -o out/${file%.asm}.o
        if [ $? -ne 0 ]; then
            echo "[Failed]"
            exit 1
        fi
        CORE_OBJ_FILES="$CORE_OBJ_FILES out/${file%.asm}.o"
    done
    
    echo "[Compiling and linking tests...]"
    for test in "${TEST_FILES[@]}"; do
        nasm -f elf32 test/$test -o out/test/obj/${test%.asm}.o
        if [ $? -ne 0 ]; then
            echo "[Failed]"
            exit 1
        fi
        
        test_name=$(basename ${test%.asm})
        ld -m elf_i386 $CORE_OBJ_FILES out/test/obj/${test%.asm}.o -o out/test/${test_name}
        if [ $? -ne 0 ]; then
            echo "[Failed]"
            exit 1
        fi
        echo "  Built: out/test/${test_name}"
    done
    
    echo "[Built]"
    
    if [ "$RUN" = true ]; then
        echo "[Running tests...]"
        for test in "${TEST_FILES[@]}"; do
            test_name=$(basename ${test%.asm})
            echo "  Running: $test_name"
            ./out/test/${test_name}
            echo ""
        done
    fi
else
    ALL_FILES=("main.asm" "${CORE_FILES[@]}")
    
    echo "[Compiling...]"
    OBJ_FILES=""
    for file in "${ALL_FILES[@]}"; do
        nasm -f elf32 src/$file -o out/${file%.asm}.o
        if [ $? -ne 0 ]; then
            echo "[Failed]"
            exit 1
        fi
        OBJ_FILES="$OBJ_FILES out/${file%.asm}.o"
    done
    
    echo "[Linking...]"
    ld -m elf_i386 $OBJ_FILES -o out/${NAME}
    if [ $? -eq 0 ]; then
        echo "[Built]"
        if [ "$RUN" = true ]; then
            echo "[Running...]"
            ./out/${NAME}
        fi
    else
        echo "[Failed]"
        exit 1
    fi
fi

echo "[Finished]"