import os
import fuzzy.vcfg

fn data_setup() &vcfg.Vcfg {
  cfg := vcfg.new_parser('example.ini', true, true)
  cfg.parse()
  return cfg
}

fn test_global_string_value() {
  cfg := data_setup()
  assert cfg.get_item('global', 'test') == 'testval'
}

fn test_global_string_set_value() {
  cfg := data_setup()
  cfg.set_item('global', 'dynamic', 'test')
  assert cfg.get_item('global', 'dynamic') == 'test'
}

fn test_section_string_value() {
  cfg := data_setup()
  assert cfg.get_item('test', 'test') == 'test'
}

fn test_section_string_set_value() {
  cfg := data_setup()
  cfg.set_item('test', 'newkey', 'value')
  assert cfg.get_item('test', 'newkey') == 'value'
}

fn test_interpolated_string_value() {
  cfg := data_setup()
  assert cfg.get_item('test', 'interpolation') == 'testval'
}

fn test_interpolated2_string_value() {
  cfg := data_setup()
  assert cfg.get_item('test', 'interpolation2') == 'testval/testval'
}

fn test_interpolated_implied_global_section_string_value() {
  cfg := data_setup()
  assert cfg.get_item('test', 'implied_global') == 'testval'
}

fn test_unsafe_env_interpolation() {
  cfg := data_setup()
  assert cfg.get_item('test', 'unsafe_env') == os.getenv('HOME')
}

fn test_value_set_with_interpolation() {
  cfg := data_setup()
  cfg.set_item('test', 'interkey', '{test}')
  assert cfg.get_item('test', 'interkey') == 'testval'
}
