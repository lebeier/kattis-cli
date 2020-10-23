#!/usr/bin/env bash

url="https://open.kattis.com/login/email?"
useragent="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0"

extract_csrf_token() {
  local http_content=$1
  csrf=$(echo "${http_content}" | grep "csrf_token" | tail -n 1 | sed 's/.*value="\([^"]*\)".*/\1/g')
}

visit_page() {
  echo $1
  local content=$(curl -sL -c cookies -b cookies \
    -H $useragent \
    $url)
  extract_csrf_token "$content"
}

main() {
  username=$1
  password=$2

  visit_page
  curl -sL -c cookies -b cookies \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "csrf_token=${csrf}&user=${username}&password=${password}&submit=Submit" \
    $url > /dev/null
}

main $@
