# Salesforce IP Address Anomaly Tracking

Code for detecting and logging IP address anomalies. This uses the Transaction Security Policies process to determine if a session is being used from an IP address different than the login IP Address

![List View](.docs/IP_Anomaly_List_View_Zoom.png)

![List View](.docs/IP_Anomaly_List_View.png)

## Creating the scratch org

```bash
sfdx force:org:create --definitionfile config/ip-anomaly-scratch-def.json --durationdays 30 --setalias IpAnomalyScr edition=Developer --targetdevhubusername JMA-CliSec
```
