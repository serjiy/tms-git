# Проверка доступности IP-адресов через ping
import subprocess
import platform

def check_ip_ping(ip_list, output_file="ping_results.txt"):
    with open(output_file, "w", encoding="utf-8") as f:
        for ip in ip_list:
            # Определяем параметр для ping в зависимости от ОС
            param = "-n" if platform.system().lower() == "windows" else "-c"
            # Выполняем ping (1 пакет)
            result = subprocess.run(["ping", param, "1", ip], 
                                  stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            status = "ДОСТУПЕН" if result.returncode == 0 else "НЕДОСТУПЕН"
            line = f"{ip} — {status}\n"
            f.write(line)
            print(line.strip())

# Пример использования
# ips = ["8.8.8.8", "google.com", "192.168.1.999", "ya.ru"]
# check_ip_ping(ips)