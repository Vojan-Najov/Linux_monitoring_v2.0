#!/usr/bin/awk -f

BEGIN {
  FPAT = "([^ ]+)|(\"[^\"]+\")|(\\[[^\\[\\]]+\\])"
}
{
  lines[NR] = $0
  codes[NR] = $6
}
END {
  insert_sort(codes, lines, NR);
  for (i = 1; i <= NR; ++i) {
    print lines[i]
  }
}

function insert_sort(CODES, LINES, n, i, j) {
  for (i = 2; i <= n; ++i) {
    j = i;
    c = CODES[j]
    l = LINES[j]
    while (j > 0 && CODES[j - 1] > c) {
      --j;
      CODES[j + 1] = CODES[j];
      LINES[j + 1] = LINES[j];
    }
    CODES[j] = c;
    LINES[j] = l;
  }
}
