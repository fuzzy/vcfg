// Copyright 2020 Mike 'Fuzzy' Partin <fuzzy@thwap.org>
// This code is released under the Copyfree Open Initiative License
// See LICENSE.md for a copy of the license terms and conditions

module vcfg

import os

pub struct Vcfg {
mut:
  contents string
  tokens   []string
  data     map[string]map[string]string
pub:
  file   string
  interp bool
  danger bool
}

pub fn new_parser(f string, i, u bool) &Vcfg {
  if !os.exists(f) {
    panic('Specified file does not exist.')
  }
  return &Vcfg{
    contents: os.read_file(f),
    tokens: []string{},
    data: map[string]map[string]string
    file: f,
    interp: i,
    danger: u
  }
}

fn (mut cf Vcfg) tokenize() {
  cf.contents = os.read_file(cf.file) or {
    panic('$err')
  }
  data_l := cf.contents.split('\n')
  cf.tokens = []string{}
  for lne in data_l {
    for tok in lne.split(' ') {
      if tok.len >= 1 {
        cf.tokens << tok
      }
    }
    cf.tokens << 'NL_TOK'
  }
}


pub fn (mut cf Vcfg) parse() {
  cf.data['global'] = map[string]string
  cf.tokenize()

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

