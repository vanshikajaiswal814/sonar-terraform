import json

def transform_sarif_to_sonarqube(sarif_report):
    sonarqube_report = {
        "issues": []
    }

    for run in sarif_report.get("runs", []):
        tool_name = run.get("tool", {}).get("driver", {}).get("name", "Unknown Tool")
        tool_version = run.get("tool", {}).get("driver", {}).get("version", "Unknown Version")
        for result in run.get("results", []):
            rule_id = result.get("ruleId", "Unknown Rule")
            rule_index = result.get("ruleIndex", 0)
            level = result.get("level", "warning").upper()
            message = result.get("message", {}).get("text", "")
            for location in result.get("locations", []):
                physical_location = location.get("physicalLocation", {})
                artifact_location = physical_location.get("artifactLocation", {})
                uri = artifact_location.get("uri", "")
                region = physical_location.get("region", {})
                start_line = region.get("startLine", 0)
                end_line = region.get("endLine", start_line)
                start_column = region.get("startColumn", 0)
                end_column = region.get("endColumn", start_column)
                
                issue = {
                    "engineId": tool_name,
                    "ruleId": rule_id,
                    "severity": level,
                    "type": "VULNERABILITY",
                    "primaryLocation": {
                        "message": message,
                        "filePath": uri,
                        "textRange": {
                            "startLine": start_line,
                            "endLine": end_line,
                            "startColumn": start_column,
                            "endColumn": end_column
                        }
                    }
                }
                sonarqube_report["issues"].append(issue)

    return sonarqube_report

# Load the SARIF report
with open('trivy_report.sarif', 'r') as file:
    sarif_report = json.load(file)

# Transform the SARIF report to SonarQube format
sonarqube_report = transform_sarif_to_sonarqube(sarif_report)

# Save the SonarQube report
with open('trivy_report_sonarqube.json', 'w') as file:
    json.dump(sonarqube_report, file, indent=4)

print("Transformation complete. The SonarQube report has been saved as 'trivy_report_sonarqube.json'.")
