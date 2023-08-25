import win32com.client
import json


def get_software_info():
    software_info = []

    obj_wmi = win32com.client.Dispatch("WbemScripting.SWbemLocator")
    obj_sw = obj_wmi.ConnectServer(".", "root\cimv2")
    col_products = obj_sw.ExecQuery("SELECT * FROM Win32_Product")

    for obj_product in col_products:
        software_info.append(
            {
                "Name": obj_product.Name,
                "Version": obj_product.Version,
                "Vendor": obj_product.Vendor,
                "InstallDate": obj_product.InstallDate,
                "Description": obj_product.Description,
                "Caption": obj_product.Caption,
                "IdentifyingNumber": obj_product.IdentifyingNumber,
                "InstallLocation": obj_product.InstallLocation,
                "PackageCache": obj_product.PackageCache,
                "SKUNumber": obj_product.SKUNumber,
                "URLInfoAbout": obj_product.URLInfoAbout,
                "URLUpdateInfo": obj_product.URLUpdateInfo,
            }
        )

    # Write to JSON file
    with open("software_info.json", "w") as file:
        json.dump(software_info, file, indent=4)


get_software_info()
