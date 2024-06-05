import winreg
import wmi


def get_software_info():
    software_info = []
    keys = [winreg.HKEY_LOCAL_MACHINE, winreg.HKEY_CURRENT_USER]

    for key in keys:
        subkey = r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
        with winreg.OpenKey(key, subkey) as main_key:
            for i in range(0, winreg.QueryInfoKey(main_key)[0]):
                try:
                    software_key_name = winreg.EnumKey(main_key, i)
                    with winreg.OpenKey(main_key, software_key_name) as software_key:
                        name, _ = winreg.QueryValueEx(software_key, "DisplayName")
                        version, _ = winreg.QueryValueEx(software_key, "DisplayVersion")
                        software_info.append({"Name": name, "Version": version})
                except:
                    pass

    return software_info


def get_hardware_info():
    c = wmi.WMI()
    hardware_info = []

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

    return hardware_info


software_info = get_software_info()
hardware_info = get_hardware_info()

# Write to log files
with open("software_info_2.log", "w") as file:
    for software in software_info:
        file.write(f"Name: {software['Name']}, Version: {software['Version']}\n")

with open("hardware_info_2.log", "w") as file:
    for hardware in hardware_info:
        file.write(
            f"Manufacturer: {hardware['Manufacturer']}, Model: {hardware['Model']}, Name: {hardware['Name']}, Number Of Processors: {hardware['NumberOfProcessors']}, System Type: {hardware['SystemType']}\n"
        )
