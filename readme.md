## Base yotta Target Description for all mbed OS targets

This is a base [yotta target
description](http://docs.yottabuild.org/tutorial/targets.html) for compiling
mbed OS. Other target descriptions can inherit
from it and add or override things as necessary (such as the link script, or
preprocessor definitions).

You should not select this target to compile with directly (compilation will
probably not succeed without target-specific startup code).

See [CHANGELOG.md](CHANGELOG.md) for the changes associated with
each version.

## Selecting the Toolchain
This target description supports both the `arm-none-eabi-gcc` and `armcc`
(version 5) compilers. The toolchain to be used can be specified in the [yotta
config](http://yottadocs.mbed.com/reference/config.html) defined by a derived
target or an application.

Derived targets must specify a default toolchain, for example in the derived
`target.json` file:

```JSON
   "config": {
     "mbed": {
        "toolchain": "gcc"
     }
   }
```


## Code Coverage
The gcc toolchain will build with -gcov if `debug.options.coverage` is set in
the yotta config. See the
[mbed-gcc](https://github.com/ARMmbed/target-mbed-gcc) derived target for
details.

