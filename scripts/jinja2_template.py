# Copyright (c) 2016, ARM Limited, All Rights Reserved
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import sys
import json
from jinja2 import Environment, FileSystemLoader

def replace_hyphens_in_keys(dictionary):
    result = {}
    # yotta config consists out of nested dictionaries only.
    for key in dictionary:
        if isinstance(dictionary[key], dict):
            # \o/ for recursion
            value = replace_hyphens_in_keys(dictionary[key])
        else:
            value = dictionary[key]
        # the actual work is done here
        result[key.replace('-', '_')] = value

    return result

def load_config(configfile):
    # load and parse the yotta config JSON file
    with open(configfile, "r") as jsonfile:
        config = json.load(jsonfile)

    # replace all hyphens in keys with underscores
    # this is required so that keys can be accessed in a Jinja2 template!
    # {% set value = config.key %} won't work with a hyphen in the key
    config = replace_hyphens_in_keys(config)

    return config


def render_with_config(source, destination, config):
    # create the Jinja2 environment
    env = Environment(loader=FileSystemLoader(os.path.dirname(source)), trim_blocks=True, lstrip_blocks=True)

    # open the template source file
    template = env.get_template(os.path.basename(source))

    # render the template with the yotta configuration
    output = template.render(**config)

    # write the generated content to the destination file
    with open(destination, "w") as outputfile:
        outputfile.write(output)


if __name__ == "__main__":
    config = load_config(sys.argv[1])
    render_with_config(sys.argv[2], sys.argv[3], config)