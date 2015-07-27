TAG=$1
OUT="${TAG}.md"


if [ -f $OUT ]; then
  echo "ERROR! ${OUT} already exists."
  exit 1
fi

echo "# \`@${TAG}\`" > $OUT
echo "" >> $OUT
echo "*TODO*" >> $OUT


