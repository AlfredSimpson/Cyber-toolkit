import psutil


def get_endpoints():
    connections = psutil.net_connections(kind="inet")
    endpoints = []

    for conn in connections:
        local_address = conn.laddr
        remote_address = conn.raddr
        status = conn.status
        pid = conn.pid
        try:
            process_name = psutil.Process(pid).name() if pid else "N/A"
        except:
            process_name = "N/A"

        endpoints.append(
            {
                "local_ip": local_address.ip,
                "remote_ip": remote_address.ip if remote_address else "N/A",
                "status": status,
                "pid": pid,
                "process_name": process_name,
            }
        )

    return sorted(endpoints, key=lambda x: x["local_ip"])


endpoints = get_endpoints()

with open("endpoints.log", "w") as file:
    for endpoint in endpoints:
        file.write(
            f"Local IP: {endpoint['local_ip']}, Remote IP: {endpoint['remote_ip']}, Status: {endpoint['status']}, PID: {endpoint['pid']}, Process Name: {endpoint['process_name']}\n"
        )
