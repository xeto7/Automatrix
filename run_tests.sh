#!/bin/bash

# Run Ansible playbook and capture output
echo "🔍 Running Ansible tests..."
ansible-playbook site.yaml --tags tests | tee report.log

# Run the report parser
echo "📊 Generating test summary..."
python report.py

echo "✅ Test report saved as: preport.log"