# vcfg is a configuration file parsing library

Vcfg's planned feature set supports an extended ini file syntax, complete with nested sections, and variable interpolation, completed by 
environment variable interpolation.

See the example.ini file for more information about the planned syntax.

Using the config file as config.ini:

```ini
key = global value

[section]
key = value
```

and the following code:

```v
module main

import vcfg

fn main() {
  cfg := vcfg.new_parser('config.ini', false, false)
  cfg.parse()
  println(cfg.data['global']['key'])
  println(cfg.data['section']['key'])
}
```

would print:

```
global value
value
```

