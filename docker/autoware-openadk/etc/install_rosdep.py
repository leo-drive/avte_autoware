import os
import sys

# check arguments
if len(sys.argv) != 2:
    print("Usage: python install_rosdep.py <rosdep file>")
    sys.exit(1)

# read from file
with open(sys.argv[1], 'r') as f:
    text = f.read()

# remove comments and empty lines and execute each line
lines = text.split('\n')
for line in lines:
    if line.strip().startswith('#'):
        continue
    if line.strip() != '':
        print(line.strip())
        os.system("DEBIAN_FRONTEND=noninteractive " + line.strip())