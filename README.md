# Salesforce IP Address Anomaly Tracking

Code for detecting and logging IP address anomalies. This uses the Event Policy process to determine if a session is being used from an IP address different than the login IP Address


## Creating the scratch org

```bash
sfdx force:org:create --definitionfile config/ip-anomaly-scratch-def.json --durationdays 30 --setalias IpAnomalyScr edition=Developer --targetdevhubusername JMA-CliSec
```
