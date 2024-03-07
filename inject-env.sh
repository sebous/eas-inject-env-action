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
Invalid input, expected input to start with |-
Example:

env_vars: |-
  ONE=1
  TWO=2
'

# trim leading whitespaces and validate that input starts with a |-
input=$(sed -e 's/^[[:space:]]*//' <<<"$input")
[[ $input == "|-"* ]] || {
	echo $err_message
	exit 1
}

json=$(jq -nR '[inputs | select(test("^[^#][^|-]")) | split("=") | {(.[0]): .[1]}] | add' <<<"$input")

# insert json object into eas.json
jq --arg env "$env" --argjson json "$json" '.build[$env].env = $json' $path >temp.json
mv temp.json $path
