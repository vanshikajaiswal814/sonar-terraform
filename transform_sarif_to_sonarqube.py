import json

def transform_sarif_to_sonarqube(sarif_report):
    sonarqube_report = {
        "rules": [],
        "issues": []
    }

    rule_map = {}

    for run in sarif_report.get("runs", []):
        tool_name = run.get("tool", {}).get("driver", {}).get("name", "Unknown Tool")
        for result in run.get("results", []):
            rule_id = result.get("ruleId", "Unknown Rule")
            if rule_id not in rule_map:
                rule_map[rule_id] = {
                    "id": rule_id,
                    "name": rule_id,  # You might need to extract a more meaningful name if available
                    "description": "Description not available",  # Update if description is available
                    "engineId": tool_name,
                    "cleanCodeAttribute": "UNKNOWN",  # Adjust based on available data
                    "impacts": []  # Populate if impact data is available
                }
            level = result.get("level", "warning").upper()
            message = result.get("message", {}).get("text", "")
            severity = map_severity(level)
            
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
                    "ruleId": rule_id,
                    "effortMinutes": 40,  # Adjust based on available data
                    "primaryLocation": {
                        "message": message,
                        "filePath": uri,
                        "textRange": {
                            "startLine": start_line,
                            "endLine": end_line,
                            "startColumn": start_column,
                            "endColumn": end_column
                        }
                    },
                    "secondaryLocations": []  # Populate if secondary locations are available
                }

                # Add secondary locations if available
                if "locations" in result:
                    for loc in result["locations"]:
                        if loc != location:  # Skip the primary location
                            sec_physical_location = loc.get("physicalLocation", {})
                            sec_artifact_location = sec_physical_location.get("artifactLocation", {})
                            sec_uri = sec_artifact_location.get("uri", "")
                            sec_region = sec_physical_location.get("region", {})
                            sec_start_line = sec_region.get("startLine", 0)
                            sec_end_line = sec_region.get("endLine", sec_start_line)
                            sec_start_column = sec_region.get("startColumn", 0)
                            sec_end_column = sec_region.get("endColumn", sec_start_column)
                            
                            secondary_location = {
                                "message": message,
                                "filePath": sec_uri,
                                "textRange": {
                                    "startLine": sec_start_line,
                                    "endLine": sec_end_line,
                                    "startColumn": sec_start_column,
                                    "endColumn": sec_end_column
                                }
                            }
                            issue["secondaryLocations"].append(secondary_location)

                sonarqube_report["issues"].append(issue)
    
    # Add rules to the report
    sonarqube_report["rules"] = list(rule_map.values())
    
    return sonarqube_report

def map_severity(level):
    severity_map = {
        "ERROR": "BLOCKER",
        "WARNING": "CRITICAL",
        "NOTICE": "MAJOR",  # Assuming NOTICE can be mapped to MAJOR
        "INFO": "MINOR"
    }
    return severity_map.get(level, "INFO")  # Default to INFO if level is unknown

# Load the SARIF report
with open('trivy_report.sarif', 'r') as file:
    sarif_report = json.load(file)

# Transform the SARIF report to SonarQube format
sonarqube_report = transform_sarif_to_sonarqube(sarif_report)

# Save the SonarQube report
with open('trivy_report_sonarqube.json', 'w') as file:
    json.dump(sonarqube_report, file, indent=4)

print("Transformation complete. The SonarQube report has been saved as 'trivy_report_sonarqube.json'.")
