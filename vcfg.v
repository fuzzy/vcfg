// Copyright 2020 Mike 'Fuzzy' Partin <fuzzy@thwap.org>
// This code is released under the Copyfree Open Initiative License
// See LICENSE.md for a copy of the license terms and conditions

module vcfg

import os

pub struct Vcfg {
mut:
  contents    string
  tokens      []string
pub mut:
  data        map[string]map[string]string
pub:
  file        string
  interpolate bool
  danger      bool
}

pub fn new_parser(f string, i, u bool) &Vcfg {
  if !os.exists(f) {
    panic('Specified file does not exist.')
  }
  data_t :=os.read_file(f) or {
    panic('$err')
  }
  return &Vcfg{
    contents: data_t,
    tokens: []string{},
    data: map[string]map[string]string
    file: f,
    interpolate: i,
    danger: u
  }
}

pub fn (mut cf Vcfg) parse() {
  cf.tokenize()
  cf.do_parse()
  cf.analyzer()
}

fn (mut cf Vcfg) tokenize() {
  data_l := cf.contents.split('\n')
  for lne in data_l {
    for tok in lne.split(' ') {
      if tok.len >= 1 {
        cf.tokens << tok
      }
    }
    cf.tokens << 'NL_TOK'
  }
}


fn (mut cf Vcfg) do_parse() {
  // initialize our base section
  cf.data['global'] = map[string]string

  // set some state variables for tracking during parsing
  mut comment := false     // flag comment lines
  mut assignment := false  // flag assignment lines
  mut section := 'global'  // the current section
  mut buffer := []string{} // buffer for current value
  mut last := string{}     // the last token processed
  mut index := 0           // the index of the current token
  mut vindex := -1         // the index of the start of our value

  // now we can start to process our tokens
  for tkn in cf.tokens {
    if comment {
      // since we know we're in a comment, let's clear the flag
      // now that we've hit the newline
      if tkn == 'NL_TOK' {
        comment = false
      }
    } else if assignment {
      if tkn == 'NL_TOK' {
        value := buffer.join(' ')
        cf.data[section][last] = value
        assignment = false
        buffer = []string{}
      } else {
        buffer << tkn
      }
    } else {
      // detect start-of-comment tokens 
      // TODO:FEATURE make this configurable 
      if tkn == '#' || tkn == ';;' {
        comment = true
      } else if tkn[0] == byte(`[`) {
        // section name parsing could probably be done better
        section = tkn.split('[')[1].split(']')[0]
        // make sure we initialize our new section
        cf.data[section] = map[string]string
      } else if tkn == '=' {
        // basic ini style assignment
        vindex = index++  // set our value starting index
        assignment = true // flag assignment state 
      }
    }
    if !assignment {
      last = tkn
    }
    index++
  }
}

fn (mut cf Vcfg) analyzer() {
  if cf.interpolate {
    for k, v in cf.data {
      for kk, vv in v {
        mut tkns := vv.split(' ')
        for idx, vvv in tkns {
          if vvv[0] == `{` {
            token := vvv.split('{')[1].split('}')[0]
            if token.contains(':') {
              tmp := token.split(':')
              val := cf.data[tmp[0]][tmp[1]]
              tkns[idx] = val
            } else if token.contains('|') && cf.danger {
              tmp := token.split('|')
              if tmp[0] == 'env' {
                tkns[idx] = os.getenv(tmp[1])
              }
            } else {
              tkns[idx] = cf.data['global'][token]
            }
          }
        }
        if tkns != vv.split(' ') {
          cf.data[k][kk] = tkns.join(' ')
        }
      }
    }
  }
}
