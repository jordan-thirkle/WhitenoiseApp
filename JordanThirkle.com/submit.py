import sys
import subprocess

def run_command(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error running command: {cmd}\n{result.stderr}")
        sys.exit(1)
    return result.stdout.strip()

print(run_command("git rev-parse --abbrev-ref HEAD"))
