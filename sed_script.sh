# #!/bin/bash

function usage() {
    echo "USAGE $0 [-f filepath] [-d filepath] [-h]"
    echo "-f to fix leading/trailing white spaces"
    echo "-d to display lines without trailing/leading white spaces"
    exit 1
}
FIX=0
DISPLAY=0
if [ $# -eq 0 ]; then
    usage
fi

while [ $# -gt 0 ]
do
    case "$1" in
        -f|--fix )
            if [ -f "$2" ]; then
                FILE=$2
                FIX=1
                shift
                shift
            else
                usage
            fi
            ;;

        -d|--display )
            if [ -f "$2" ]; then
                FILE=$2
                DISPLAY=1
                shift
                shift
            else
                usage
            fi
            ;;

        -h|--help )
            usage
            ;;
        * )
        usage
    esac
done

if [ $FIX -eq 1 ] && [ -f "$FILE" ]; then
    echo "Fxing spaces and tabs at the beginning and end of each line."
    sed -i -r 's/^[[:space:]]+//' $FILE
    sed -i -r 's/[[:space:]]+$//' $FILE
    echo -e "\e[1;42m[Done]\e[0m"
fi

# Display graphically the space errors
if [ $DISPLAY -eq 1 ] && [ -f "$FILE" ]; then
    NUM=0
    while IFS= read -r line # Add IFS= option before read command to prevent
                             # leading/trailing whitespace from being trimmed
    # -r in read command to prevents backslash escapes from being interpreted.
    do
        let NUM++
        R="^[[:blank:]]+"
        E="[[:blank:]]+$"
        echo "$line" | sed  -n -r -e '/[[:space:]]+$/q2'  -r -e '/^[[:space:]]+/q3'
        if [ $? -eq 0 ]; then
            printf "%+4s:" $NUM >> temp.txt
            echo "$line" >> temp.txt
            continue;
        fi
        printf "%+4s:" $NUM >> temp.txt

        if [[ "$line" =~ $R ]]; then
        #if execution came here then there is a leading white space
            MATCH=`echo "$BASH_REMATCH" | sed 's/\t/|TAB|/g'`
            echo  -e -n  "\e[1;41m$MATCH\e[49m" >> temp.txt
        fi

        echo -e -n "$line" | sed -r 's/^\s+|\s+$//g' >> temp.txt

        if [[ "$line" =~ $E ]]; then
        #if execution came here then there is a trailing white space
            MATCH=`echo "$BASH_REMATCH" | sed 's/\t/|TAB|/g'`
            echo  -e  -n "\e[1;44m$MATCH\e[49m" >> temp.txt
        fi
        echo "" >>  temp.txt
    done < "$FILE"

    cat temp.txt
    rm temp.txt
fi
