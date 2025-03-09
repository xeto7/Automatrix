#!/usr/bin/python

# Copyright: (c) 2025, Kevin Thomas <ket189@pitt.edu>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import absolute_import, division, print_function

__metaclass__ = type

DOCUMENTATION = r"""
---
module: xxd

short_description: Runs xxd on a file and returns the hex dump.

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This module takes a file path as input and returns its xxd hex dump, split by line.

options:
    path:
        description: The path to the file to be processed with xxd.
        required: true
        type: str
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
# extends_documentation_fragment:
#     - my_namespace.my_collection.my_doc_fragment_name
        
author:
    - Kevin Thomas (@mytechnotalent)
"""

EXAMPLES = r"""
# Run xxd on a file
- name: Run xxd on a file
  my_namespace.my_collection.xxd:
    path: /home/debian/test/hello.txt
"""

RETURN = r"""
# These are examples of possible return values, and in general should use other names for return values.
original_path:
    description: The original file path provided as input.
    type: str
    returned: always
    sample: '/home/debian/test/hello.txt'
hex_dump:
    description: A list of lines from the xxd command output.
    type: list
    elements: str
    returned: always
    sample:
      - "00000000: 4865 6c6c 6f20 6672 6f6d 2041 6e73 6962  Hello from Ansib"
      - "00000010: 6c65 21                                  le!"
"""

import os
import subprocess
from ansible.module_utils.basic import AnsibleModule


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(path=dict(type="str", required=True))

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(changed=False, original_path="", hex_dump=[])

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(argument_spec=module_args, supports_check_mode=True)

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    file_path = module.params["path"]
    result["original_path"] = file_path

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    if not os.path.exists(file_path):
        module.fail_json(msg="File not found: {}".format(file_path), **result)

    # custom logic
    try:
        xxd_output = subprocess.check_output(
            ["xxd", file_path], universal_newlines=True
        )
        # split by line so Ansible 'debug: var=' shows each line properly
        lines = xxd_output.rstrip("\n").split("\n")
        result["hex_dump"] = lines
    except subprocess.CalledProcessError as e:
        module.fail_json(msg="Failed to run xxd: {}".format(e), **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == "__main__":
    main()
