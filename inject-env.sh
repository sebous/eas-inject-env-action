#!/bin/bash

# accept arguments input, env, path
while getopts ":i:p:e:" opt; do
	case $opt in
	i)
		input="$OPTARG"
		;;
	p)
		path="$OPTARG"
		;;
	e)
		env="$OPTARG"
		;;
	\?)
		echo "Invalid option -$OPTARG" >&2
		;;
	esac
done

# Check if all three required arguments are provided
if [ -z "$input" ] || [ -z "$path" ] || [ -z "$env" ]; then
	echo "Usage: $0 -i <input> -p <path> -e <env>"
	exit 1
fi

err_message='
Invalid input, expected input formatted like below:
env_vars: |-
  ONE=1
  TWO=2
'

# trim leading whitespaces
input=$(sed -e 's/^[[:space:]]*//' <<<"$input")

json=$(jq -nR '[inputs | select(test("^[^#][^|-]")) | split("=") | {(.[0]): .[1]}] | add' <<<"$input")

# insert json object into eas.json
jq --arg env "$env" --argjson json "$json" '.build[$env].env = $json' $path >temp.json

mv temp.json $path

keys=$(jq -nR '[inputs | select(test("^[^#][^|-]")) | split("=") | .[0]]' <<<"$input")
echo "Environment variables loaded into eas.json file: $keys"
