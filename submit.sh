#!/usr/bin/env bash

url="https://open.kattis.com/login/email?"
useragent="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0"

extract_csrf_token() {
  local http_content=$1
  csrf=$(echo "${http_content}" | grep "csrf_token" | tail -n 1 | sed 's/.*value="\([^"]*\)".*/\1/g')
}

get_submit_ctr() {
  local http_content=$1
  submit_ctr=$(echo "${http_content}" | grep "submit_ctr" | head -n 1 | sed 's/.*value="\([^"]*\)".*/\1/g')
}

main() {
  problem=$1
  filename=$2

  local content=$(curl -sL -c cookies -b cookies \
    -H $useragent https://open.kattis.com/problems/${problem}/submit)

  extract_csrf_token "$content"
  echo $csrf
  get_submit_ctr "$content"
  echo $submit_ctr
  curl -sL -c cookies -b cookies \
    -F "csrf_token=${csrf}" \
    -F "type=files" \
    -F "sub_file[]=@${filename}" \
    -F "problem=${problem}" \
    -F "language=C++" \
    -F "submit=Submit" \
    -F "submit_ctr=${submit_ctr}" \
    https://open.kattis.com/problems/${problem}/submit > /dev/null
}

main $@
