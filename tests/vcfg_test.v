import fuzzy.vcfg

fn test_global_string_value() {
  data := vcfg.parse('example.ini')
  assert data['global']['test'] == 'test'
}
