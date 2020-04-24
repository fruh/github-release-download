#!/bin/bash
git_url=$1
version_file=$2
dest_file=$3
grep_exp_down_url=$4

if [ "$1" == "" -o "$2" == "" -o "$3" == "" -o "$4" == "" ]; then

    echo "Usage: $0 git_url version_file dest_file grep_exp_down_url"

    exit 1
fi

json_data=`curl -s "$git_url"`

new_version=`echo "$json_data" | jq .tag_name -r`

if [ -f "$version_file" ]; then

    old_version="`cat \"$version_file\"`"

else

    old_version=""

fi

if [ "$old_version" != "$new_version" ]; then

    all_download_urls=`echo "$json_data" | jq '.assets[]|.browser_download_url' -r`

    download_url=`echo "$all_download_urls" | grep -E "$grep_exp_down_url"`

    curl -L "$download_url" -o "$dest_file" && echo -n "$new_version" > "$version_file"
else

    echo "No new version available, installed \"$old_version\" new \"$new_version\""

fi
