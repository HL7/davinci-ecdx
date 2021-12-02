#!/bin/bash
# exit when any command fails
set -e

echo "================================================================="
echo "=== commit and load to github for autopublisher ==="
echo "================================================================="

inpath=input
for folder in includes-yaml examples-yaml resources-yaml
do
if ls $inpath/$folder/*.yml; then
echo "======================================================================="
echo "convert all yml files in $folder directory to json files"
echo "Python 3.7 and PyYAML, json and sys modules are required"
for yaml_file in $inpath/$folder/*.yml
do
echo $yaml_file
json_file=$inpath/${folder%-*}/$(basename $yaml_file)
json_file=${json_file%.*}.json
echo $json_file
python3.7 -c 'import sys, yaml, json; json.dump(yaml.full_load(sys.stdin), sys.stdout, indent=4)' < $yaml_file > $json_file
done
echo "========================================================================"
fi
done

echo "================================================================="

echo "================================================================="
echo "=== rename the 'input/fsh' folder to 'input/_fsh'  ==="
echo "================================================================="
trap "echo '=== rename the input/_fsh folder to input/fsh  ==='; mv input/_fsh input/fsh" EXIT
[[ -d input/fsh ]] && mv input/fsh input/_fsh

git status

echo "================================================================="
echo "=== hit 'a' to commit and push all including untracked files ===="
echo "=== else 'c' for only tracked file or ctrl-c to exit ==="
echo "================================================================="

read var1

echo "================================================================="
echo "==================== you typed '$var1' ============================"
echo "================================================================="

if [ $var1 == "c" ]; then
  git commit -a
  git push
elif [ $var1 == "a" ]; then
  git add .
  git commit
  git push
fi
