import fuzzy.vcfg

fn test_global_string_value() {
  cfg := vcfg.new_parser('example.ini', false, false)
  cfg.parse()
  assert cfg.data['global']['test'] == 'test'
}

fn test_section_string_value() {
  cfg := vcfg.new_parser('example.ini', false, false)
  cfg.parse()
  assert cfg.data['test']['test'] == 'test'
}
