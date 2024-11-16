import os
import re
import json

def extract_ddl_statements(file_path):
    with open(file_path, 'r') as file:
        sql_content = file.read()

    # Regular expression to match CREATE TABLE statements
    ddl_pattern = re.compile(r'CREATE TABLE [\s\S]+?;', re.IGNORECASE)
    ddl_statements = ddl_pattern.findall(sql_content)

    # Dictionary to store the DDL statements
    ddl_dict = {}
    for statement in ddl_statements:
        # Extract table name
        table_name_match = re.search(r'CREATE TABLE (\w+\.\w+)', statement, re.IGNORECASE)
        if table_name_match:
            table_name = table_name_match.group(1)
            ddl_dict[table_name] = statement.strip()

    return ddl_dict

def save_to_json(data, output_file):
    with open(output_file, 'w') as json_file:
        json.dump(data, json_file, indent=4)

if __name__ == "__main__":
    
    cwd = os.getcwd()
    print("Current Working Directory:", cwd)
    input_file = 'python/OMOPCDM_synapse_5.4_ddl.sql'
    output_file = 'ddl_statements.json'

    ddl_statements = extract_ddl_statements(input_file)
    save_to_json(ddl_statements, output_file)

    print(f"Extracted DDL statements have been saved to {output_file}")
