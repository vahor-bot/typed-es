#!/usr/bin/env bash
set -e
ESC=$'\033'
reset="${ESC}[0m"
blue="${ESC}[38;5;117m"
green="${ESC}[38;5;114m"
yellow="${ESC}[38;5;221m"
red="${ESC}[38;5;210m"
muted="${ESC}[38;5;246m"
white="${ESC}[38;5;255m"

clear_screen() { printf '%s[2J%s[H' "$ESC" "$ESC"; }
line() { printf '%s\n' "$1"; }
type_line() {
  local text=$1 char i
  for ((i=0; i<${#text}; i++)); do
    char=${text:i:1}
    printf '%s' "$char"
    sleep 0.025
  done
  printf '\n'
}
header() {
  line "${blue}typed-es demo${reset}  ${muted}live TypeScript inference${reset}"
  line "${muted}src/search.ts${reset}"
  line ""
}

clear_screen
header
line "${white}const query = {${reset}"
line '  index: "products",'
line '  _source: ["id", "name"],'
line '  aggs: { avg_price: { avg: { field: "price" } } },'
line '};'
sleep 1

clear_screen
header
line "${white}const query = {${reset}"
line '  index: "products",'
line '  _source: ["id", "name"],'
line '  aggs: { avg_price: { avg: { field: "price" } } },'
line '};'
line ""
line "${white}const result = await client.search(query);${reset}"
line "                         ${yellow}// ^? SearchResponse<unknown>${reset}"
line ""
line "${white}result.hits.hits[0]._source${reset}"
line "                     ${red}^^^^^^^^^^^^^^^^^^^^^^^^${reset}"
line "${red}Property '_source' is of type 'unknown'.${reset}"
line ""
line "${white}result.aggregations.avg_price.value${reset}"
line "       ${red}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^${reset}"
line "${red}Object is possibly 'undefined'.${reset}"
sleep 2.5

clear_screen
header
line "${white}const query = ${blue}typedEs(client, {${reset}"
line '  index: "products",'
line '  _source: ["id", "name"],'
line '  aggs: { avg_price: { avg: { field: "price" } } },'
line '});'
line ""
line "${white}const result = await client.search(query);${reset}"
line "                         ${green}// ^? SearchResponse<{${reset}"
line "                         ${green}//     _source: { id: number; name: string };${reset}"
line "                         ${green}//     aggregations: { avg_price: { value: number | null } };${reset}"
line "                         ${green}//   }>${reset}"
line ""
line "${white}result.hits.hits[0]._source.id${reset}"
line "                         ${green}// ^? number${reset}"
line ""
line "${white}result.aggregations.avg_price.value${reset}"
line "       ${green}// ^? number | null${reset}"
sleep 2.5

clear_screen
header
line "${white}const query = ${blue}typedEs(client, {${reset}"
line '  index: "products",'
line "  _source: [${yellow}\"id\", \"name\", \"price\"${reset}],"
line '  aggs: { avg_price: { avg: { field: "price" } } },'
line '});'
line ""
line "${white}const result = await client.search(query);${reset}"
line "                         ${green}// ^? _source now includes price: number${reset}"
line ""
line "${yellow}Change the query. The type follows it.${reset}"
line "${muted}No duplicated interfaces. No \`as any\`.${reset}"
sleep 3
