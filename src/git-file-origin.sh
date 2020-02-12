if [ $# -eq 0 ]; then
    echo "Must supply file."
    exit 1
elif [ ! -f "$1" ]; then
    echo "File '$1' does not exist."
    exit 1
fi

echo $(git log --diff-filter=A -- $1 | sed -n "s/commit \(.*\)/\1/p")
