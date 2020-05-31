# vcfg is a configuration file parsing library

Vcfg's planned feature set supports an extended ini file syntax, complete with nested sections, and variable interpolation, completed by 
environment variable interpolation.

See the example.ini file for more information about the planned syntax.

Using the config file as config.ini:

```ini
base_dir = /home/username/.local

[dirs]
cache = {base_dir}/myapp/cache
```

and the following code:

```v
module main

import vcfg

fn main() {
  cfg := vcfg.new_parser('config.ini', true, false)
  cfg.parse()
  println(cfg.data['dirs']['cache'])
}
```

would print:

```
/home/username/.local/myapp/cache
```

