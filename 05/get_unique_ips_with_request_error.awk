#! /usr/bin/awk -f

BEGIN {
  FPAT = "([^ ]+)|(\"[^\"]+\")|(\\[[^\\[[\\]]+\\])"
}
{
  ips[NR] = $1;
  codes[NR] = $6;
  # lines[NR] = $0;
}
END {
  for (i = 1; i <= NR; ++i) {
    if (codes[i] !~ /^[4,5][0-9]{2}$/) {
      continue;
    }
    is_unique = 1;
    for (j = 1; j < i; ++j) {
      if (ips[i] == ips[j]) {
        is_unique = 0;
        break;
      }
    }
    if (is_unique == 1) {
      print codes[i] " " ips[i];
      # print ines[i];
    }
  }
}

