import fuzzy.vcfg

fn data_setup() &vcfg.Vcfg {
  cfg := vcfg.new_parser('example.ini', true, true)
  cfg.parse()
  return cfg
}

fn test_global_string_value() {
  cfg := data_setup()
  assert cfg.data['global']['test'] == 'testval'
}

fn test_section_string_value() {
  cfg := data_setup()
  assert cfg.data['test']['test'] == 'test'
}

fn test_section_string_interpolated_value() {
  cfg := data_setup()
  assert cfg.data['test']['interpolation'] == 'testval'
}

fn test_section_string_interpolated_value_implied_global_section() {
  cfg := data_setup()
  assert cfg.data['test']['implied_global'] == 'testval'
}
