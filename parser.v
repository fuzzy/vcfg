// Copyright 2020 Mike 'Fuzzy' Partin <fuzzy@thwap.org>
// This code is released under the Copyfree Open Initiative License
// See LICENSE.md for a copy of the license terms and conditions

module vcfg

import strconv

pub fn parse(fname string) map[string]map[string]string {
  mut retv := map[string]map[string]string
  tokens := tokenize(fname)

  /*
   * Some tracking variables help turn this into a simple
   * state machine. We don't need to track much as we aren't 
   * doing variable interpolation at this phase. That not only
   * greatly simplifies the code, but it also prevents undefined
   * variable errors from popping up.
   */
  mut comment := false     // flag comment lines
  mut assignment := false  // flag assignment lines
  mut section := 'global'  // the current section
  mut buffer := []string{} // buffer for current value
  mut last := string{}     // the last token processed
  mut index := 0           // the index of the current token
  mut vindex := -1         // the index of the start of our value

  // now we can start to process our tokens
  for tkn in tokens {
    if comment {
      // since we know we're in a comment, let's clear the flag
      // now that we've hit the newline
      if tkn == 'NL_TOK' {
        comment = false
      }
    } else if assignment {
      if tkn == 'NL_TOK' {
        value := buffer.join(' ').clone()
        retv[section][last] = strconv.v_sprintf('%s', value)
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
        retv[section] = map[string]string
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

  return retv
}
