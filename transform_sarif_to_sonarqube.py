import json
import os

def transform_sarif_to_sonarqube(sarif_report_path, sonarqube_output_path):
    with open(sarif_report_path, 'r') as file:
        sarif_data = json.load(file)

    sonarqube_issues = []
    for run in sarif_data['runs']:
        tool_name = run['tool']['driver']['name']
        tool_version = run['tool']['driver']['version']
        for result in run['results']:
            rule_id = result['ruleId']
            level = result['level']
            message = result['message']['text']
            for location in result['locations']:
                artifact_location = location['physicalLocation']['artifactLocation']['uri']
                start_line = location['physicalLocation']['region']['startLine']
                issue = {
                    'engineId': tool_name,
                    'ruleId': rule_id,
                    'severity': level,
                    'type': 'VULNERABILITY',
                    'primaryLocation': {
                        'message': message,
                        'filePath': artifact_location,
                        'textRange': {
                            'startLine': start_line,
                            'endLine': start_line
                        }
                    }
                }
                sonarqube_issues.append(issue)

    sonarqube_report = {
        'issues': sonarqube_issues
    }

    with open(sonarqube_output_path, 'w') as outfile:
        json.dump(sonarqube_report, outfile, indent=4)

if __name__ == "__main__":
    sarif_report_path = "trivy_report.sarif"  # Input SARIF file path
    sonarqube_output_path = "sonarqube_report.json"  # Output SonarQube file path

    if os.path.exists(sarif_report_path):
        transform_sarif_to_sonarqube(sarif_report_path, sonarqube_output_path)
        print(f"SonarQube report generated: {sonarqube_output_path}")
    else:
        print(f"Error: SARIF report not found at {sarif_report_path}")
import json
import os

def transform_sarif_to_sonarqube(sarif_report_path, sonarqube_output_path):
    with open(sarif_report_path, 'r') as file:
        sarif_data = json.load(file)

    sonarqube_issues = []
    for run in sarif_data['runs']:
        tool_name = run['tool']['driver']['name']
        tool_version = run['tool']['driver']['version']
        for result in run['results']:
            rule_id = result['ruleId']
            level = result['level']
            message = result['message']['text']
            for location in result['locations']:
                artifact_location = location['physicalLocation']['artifactLocation']['uri']
                start_line = location['physicalLocation']['region']['startLine']
                issue = {
                    'engineId': tool_name,
                    'ruleId': rule_id,
                    'severity': level,
                    'type': 'VULNERABILITY',
                    'primaryLocation': {
                        'message': message,
                        'filePath': artifact_location,
                        'textRange': {
                            'startLine': start_line,
                            'endLine': start_line
                        }
                    }
                }
                sonarqube_issues.append(issue)

    sonarqube_report = {
        'issues': sonarqube_issues
    }

    with open(sonarqube_output_path, 'w') as outfile:
        json.dump(sonarqube_report, outfile, indent=4)

if __name__ == "__main__":
    sarif_report_path = "trivy_report.sarif"  # Input SARIF file path
    sonarqube_output_path = "sonarqube_report.json"  # Output SonarQube file path

    if os.path.exists(sarif_report_path):
        transform_sarif_to_sonarqube(sarif_report_path, sonarqube_output_path)
        print(f"SonarQube report generated: {sonarqube_output_path}")
    else:
        print(f"Error: SARIF report not found at {sarif_report_path}")
