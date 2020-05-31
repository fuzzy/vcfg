# vcfg is a configuration file parsing library

Vcfg's planned feature set supports an extended ini file syntax, complete with nested sections, and variable interpolation, completed by 
environment variable interpolation.

See the example.ini file for more information about the planned syntax.

Using the config file as config.ini:

```ini
base_dir = {env|HOME}/.local

[dirs]
cache = {base_dir}/myapp/cache
```

and the following code:

```v
module main

import vcfg

fn main() {
  cfg := vcfg.new_parser('config.ini', true, true)
  cfg.parse()
  println(cfg.get_item('dirs', 'cache'))
  cfg.set_item('dirs', 'foo', 'bar')
  println(cfg.get_item('dirs', 'foo'))
}
```

would print:

```
/home/username/.local/myapp/cache
foo
```

