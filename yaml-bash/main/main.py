import yaml 
import os
import sys
import subprocess


def main():
    input_file = "main.yml"
    output_file = "workflow.sh"
    try:
        with open(input_file, "r") as f:
            workflow = yaml.safe_load(f)
    except FileNotFoundError:
        print(f"ERROR: {input_file} doesnt exist f")    
        sys.exit(1)
    except yaml.YAMLError as e:
        print(f"ERROR: YAML file is wrong: \n{e}")
        sys.exit(1)

    if "steps" not in workflow or not isinstance(workflow['steps'], list):
        print("ERROR: No steps or its not a list")
        sys.exit(1)

    with open(output_file, "w") as bash:
        bash.write("#!/bin/bash\n")
        bash.write(f"#Workflow: {workflow.get('name', 'Unnamed Workflow')}\n\n")

        for i, step in enumerate(workflow['steps'], start=1):
            name = step.get('name')
            run = step.get('run')
            if not name or not run: 
                print(f"SKIPPING INVALID STEP {i}\n")
                continue
            
            bash.write(f"#Step {i}: {name} \n\n")

            if isinstance(run, str):
                bash.write(run.strip() + "\n\n")
            elif isinstance(run, list):
                for cmd in run:
                    bash.write(cmd.strip() + "\n")
            else:
                print(f"Run format is wrong in step{i}")

    os.chmod(output_file, 0o755)
    print(f"Generated {output_file} sucesfully")

    print(f"Running the {output_file} scipt......\n")
    subprocess.run("./" + output_file)


main()