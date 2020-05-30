// Copyright 2020 Mike 'Fuzzy' Partin <fuzzy@thwap.org>
// This code is released under the Copyfree Open Initiative License
// See LICENSE.md for a copy of the license terms and conditions

module vcfg

import os

fn tokenize(fname string) []string {
  data := os.read_file(fname) or {
    panic('$err')
  }
  data_l := data.split('\n')
  mut data_t := []string{}
  for lne in data_l {
    for tok in lne.split(' ') {
      if tok.len >= 1 {
        data_t << tok
      }
    }
    data_t << 'NL_TOK'
  }
  return data_t
}

