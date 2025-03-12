import re

# Read Ansible output from file
with open("report.log", "r") as file:
    lines = file.readlines()

# Initialize filtered output and counters
filtered_output = []
passed_count = 0
failed_count = 0

# Regex patterns to identify and remove unwanted sections
play_header_pattern = re.compile(r"^PLAY \[.*\] \*+$")
gathering_facts_pattern = re.compile(r"^TASK \[Gathering Facts\] \*+$")
play_recap_pattern = re.compile(r"^PLAY RECAP \*+$")
status_summary_pattern = re.compile(r"^\S+ : ok=\d+\s+changed=\d+\s+unreachable=\d+\s+failed=\d+\s+skipped=\d+\s+rescued=\d+\s+ignored=\d+\s*$")

# Flags to track sections
skip_section = False

for line in lines:
    # Skip play headers and "Gathering Facts"
    if play_header_pattern.match(line) or gathering_facts_pattern.match(line):
        skip_section = True
        continue
    if play_recap_pattern.match(line):
        skip_section = True
        continue
    if status_summary_pattern.match(line):
        continue  # Skip the final status summary

    # Stop skipping once we move past the section
    if line.strip() == "":
        skip_section = False

    if not skip_section:
        filtered_output.append(line)

        # Count passed/failed tasks
        if "...ignoring" in line:
            failed_count += 1  # Ignored tasks should be counted as failures
        elif "ok:" in line:
            passed_count += 1  # Tasks marked as "ok" count as passes

# Append a final summary
filtered_output.append("\n=== Test Summary ===\n")
filtered_output.append(f"✅ Passed: {passed_count}\n")
filtered_output.append(f"❌ Failed: {failed_count}\n")

# Write cleaned output to a new file
with open("report.log", "w") as file:
    file.writelines(filtered_output)

print("✅ Cleaned output saved to report.log")