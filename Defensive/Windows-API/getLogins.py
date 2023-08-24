import win32com.client
import json


def get_login_attempts():
    login_attempts = []

    str_query = "SELECT * FROM Win32_NTLogEvent WHERE Logfile = 'Security' AND EventCode = '4624'"
    obj_wmi = win32com.client.Dispatch("WbemScripting.SWbemLocator")
    obj_sw = obj_wmi.ConnectServer(".", "root\cimv2")
    col_events = obj_sw.ExecQuery(str_query)

    for obj_event in col_events:
        login_attempts.append(
            {
                "EventCode": obj_event.EventCode,
                "TimeGenerated": obj_event.TimeGenerated,
                "Message": obj_event.Message,
            }
        )

    # Write to JSON file
    with open("login_attempts.json", "w") as file:
        json.dump(login_attempts, file, indent=4)


get_login_attempts()
