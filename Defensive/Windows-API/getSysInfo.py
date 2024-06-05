import win32com.client
import wmi


def get_system_info():
    software_info = []
    hardware_info = []

    # Connect to WMI
    c = wmi.WMI()

    # Getting Software Information
    strComputer = "."
    objWMIService = win32com.client.Dispatch("WbemScripting.SWbemLocator")
    objSWbemServices = objWMIService.ConnectServer(strComputer, "root\\cimv2")
    colItems = objSWbemServices.ExecQuery("Select * from Win32_Product")

    for objItem in colItems:
        software_info.append(
            {
                "Name": objItem.Name,
                "Version": objItem.Version,
                "InstallLocation": objItem.InstallLocation,
            }
        )

    # Getting Hardware Information
    for item in c.Win32_ComputerSystem():
        hardware_info.append(
            {
                "Manufacturer": item.Manufacturer,
                "Model": item.Model,
                "Name": item.Name,
                "NumberOfProcessors": item.NumberOfProcessors,
                "SystemType": item.SystemType,
            }
        )

    return software_info, hardware_info


software_info, hardware_info = get_system_info()

# Write to log files
with open("software_info.log", "w") as file:
    for software in software_info:
        file.write(
            f"Name: {software['Name']}, Version: {software['Version']}, Install Location: {software['InstallLocation']}\n"
        )

with open("hardware_info.log", "w") as file:
    for hardware in hardware_info:
        file.write(
            f"Manufacturer: {hardware['Manufacturer']}, Model: {hardware['Model']}, Name: {hardware['Name']}, Number Of Processors: {hardware['NumberOfProcessors']}, System Type: {hardware['SystemType']}\n"
        )
