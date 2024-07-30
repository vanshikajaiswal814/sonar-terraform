import json

def transform_sarif_to_sonarqube(sarif_path, output_path):
    with open(sarif_path, 'r') as sarif_file:
        sarif_data = json.load(sarif_file)
    
    sonar_report = {
        "rules": [],
        "issues": []
    }

    for run in sarif_data.get("runs", []):
        for result in run.get("results", []):
            rule_id = result.get("ruleId", "unknown")
            message = result.get("message", {}).get("text", "No message")
            locations = result.get("locations", [])

            # Example rule creation - you need to adjust based on your SARIF data
            if rule_id not in [rule["id"] for rule in sonar_report["rules"]]:
                sonar_report["rules"].append({
                    "id": rule_id,
                    "name": rule_id,
                    "description": message,
                    "engineId": "trivy",
                    "cleanCodeAttribute": "FORMATTED",
                    "impacts": [
                        {
                            "softwareQuality": "MAINTAINABILITY",
                            "severity": "HIGH"
                        }
                    ]
                })

            for location in locations:
                artifact_location = location.get("physicalLocation", {}).get("artifactLocation", {}).get("uri", "unknown")
                region = location.get("physicalLocation", {}).get("region", {})
                start_line = region.get("startLine", 1)

                sonar_report["issues"].append({
                    "ruleId": rule_id,
                    "primaryLocation": {
                        "message": message,
                        "filePath": artifact_location,
                        "textRange": {
                            "startLine": start_line
                        }
                    }
                })
    
    with open(output_path, 'w') as output_file:
        json.dump(sonar_report, output_file, indent=4)

# Run the transformation
transform_sarif_to_sonarqube('trivy_report.sarif', 'trivy_report_sonarqube.json')
