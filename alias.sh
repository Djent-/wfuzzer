#!/bin/bash

export WFUZZ_SCANS="~/Current Client/scans/wfuzz"

# Usage: wfz https://example.com/FUZZ{notthere}
wfz()
{
  domain="${1//https:\/\//}"
  domain="${domain//http:\/\//}"
  domain="${domain//:*/}"
  domain="${domain//\/*/}"
  
  num=$(ls $WFUZZ_SCANS | grep "$domain." | wc -l)
  num="$(($num + 1))"
  
  fileout="$WFUZZ_SCANS/$domain"_"$num"
  
  echo "wfz"
  
  echo "Results -> $fileout"
  echo "wfuzz --req-delay 10 --conn-delay 10 -Z -c -L --hw BBB --hc 400 -z file,/usr/share/wordlists/dirb/big.txt -f $fileout.txt,raw --script=robots,listing,title --filter \"FUZZ\!~' '\" $1"
  wfuzz --req-delay 10 --conn-delay 10 -Z -c -L --hw BBB --hc 400 -z file,/usr/share/wordlists/dirb/big.txt -f $fileout.txt,raw --script=robots,listing,title --filter "FUZZ!~' '" $1
}
