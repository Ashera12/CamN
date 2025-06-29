import os
import sys
import time
import subprocess
from colorama import init, Fore, Style

# Inisialisasi Colorama
# autoreset=True akan otomatis mengembalikan warna ke default setelah setiap print()
init(autoreset=True)

# Mendefinisikan warna menggunakan Colorama agar cross-platform
RED = Fore.RED
GREEN = Fore.GREEN
YELLOW = Fore.YELLOW
BLUE = Fore.BLUE
MAGENTA = Fore.MAGENTA
CYAN = Fore.CYAN
WHITE = Fore.WHITE
RESET = Style.RESET_ALL

# Simpan direktori awal
CWD = os.getcwd()

# FIX 1: Menambahkan 'r' di depan string untuk menjadikannya "raw string".
# Ini akan memperbaiki semua 'SyntaxWarning: invalid escape sequence'.
LOGO = r"""
{BLUE}   _   _    _    ____ _  __      ____    _    __  __ _____ ____      _   
{BLUE}  | | | |  / \  / ___| |/ /     / ___|  / \  |  \/  | ____|  _ \    / \  
{BLUE}  | |_| | / _ \| |   | ' /_____| |     / _ \ | |\/| |  _| | |_) |  / _ \ 
{BLUE}  |  _  |/ ___ \ |___| . \_____| |___ / ___ \| |  | | |___|  _ <  / ___ \ 
{BLUE}  |_| |_/_/   \_\____|_|\_\     \____/_/   \_\_|  |_|_____|_| \_\/_/   \_\

{GREEN}                             [By X PHANTOM (PH4N7OM)]

{RED}                               [By SomniumN1 (Ashera12)]

{GREEN}   The lady.....  ..              >> BiLaNazmi<< [SomniumN1]
"""

def clear_screen():
    """Membersihkan layar terminal, berfungsi di Windows, macOS, dan Linux."""
    os.system('cls' if os.name == 'nt' else 'clear')

def display_menu():
    """Menampilkan logo dan menu pilihan."""
    # Menggunakan .format() untuk memasukkan variabel warna ke dalam raw string
    print(LOGO.format(BLUE=BLUE, GREEN=GREEN, RED=RED))
    print(f"{CYAN}[1]{WHITE} CamPhish V1")
    print(f"{CYAN}[2]{WHITE} CamPhish V2")
    print(f"{CYAN}[0]{WHITE} Exit")

def run_command(command_list):
    """Menjalankan perintah eksternal dengan subprocess."""
    try:
        subprocess.run(command_list, check=True)
    except FileNotFoundError:
        print(f"{RED}Error: Perintah '{command_list[0]}' tidak ditemukan.")
        print(f"{YELLOW}Di Windows, pastikan 'bash' terinstal (misal dari Git Bash) dan ada di PATH sistem.")
        time.sleep(4)
    except subprocess.CalledProcessError as e:
        print(f"{RED}Error saat menjalankan skrip: {e}")
        time.sleep(3)
    except Exception as e:
        print(f"{RED}Terjadi kesalahan tak terduga: {e}")
        time.sleep(3)

def run_camphish_v1():
    """Fungsi untuk menjalankan CamPhish V1."""
    clear_screen()
    print(f"{WHITE}Starting CamPhish V1...")
    time.sleep(3)
    
    try:
        os.chdir("CamPhish")
        clear_screen()
        print(f"{MAGENTA}SOMNIUMN1 >>BILANAZMI<< ( ASHERA12 )")
        time.sleep(3)
        
        print(f"{YELLOW}Menjalankan 'bash camphish.sh'...")
        run_command(['bash', 'camphish.sh'])

    except FileNotFoundError:
        print(f"{RED}Error: Direktori 'CamPhish' tidak ditemukan.")
        print(f"{YELLOW}Pastikan skrip ini berada di direktori yang sama dengan folder 'CamPhish'.")
        time.sleep(4)
    finally:
        os.chdir(CWD)

def run_camphish_v2():
    """Fungsi untuk menjalankan CamPhish V2."""
    clear_screen()
    print(f"{MAGENTA}Starting CamPhish V2...")
    time.sleep(3)

    try:
        os.chdir("HACK-CAMERA")
        clear_screen()
        print(f"{MAGENTA}Installing The Tools...")
        time.sleep(3)

        print(f"{YELLOW}Menjalankan setup...")
        run_command(['bash', 'setup'])
        
        clear_screen()
        print(f"{MAGENTA}SOMNIUMN1 THAT'S NAME I LIKE")
        time.sleep(3)
        
        print(f"{YELLOW}Menjalankan 'bash hack_camera.sh'...")
        run_command(['bash', 'hack_camera.sh'])

    except FileNotFoundError:
        print(f"{RED}Error: Direktori 'HACK-CAMERA' tidak ditemukan.")
        print(f"{YELLOW}Pastikan skrip ini berada di direktori yang sama dengan folder 'HACK-CAMERA'.")
        time.sleep(4)
    finally:
        os.chdir(CWD)

def main():
    """Fungsi utama program."""
    # FIX 2: Memastikan struktur try/except ini benar untuk menghindari SyntaxError.
    while True:
        clear_screen()
        display_menu()
        
        try:
            choice = input(f"{YELLOW}Choose: {RESET}")

            if choice == '1':
                run_camphish_v1()
                input(f"\n{GREEN}Eksekusi selesai. Tekan Enter untuk kembali ke menu utama...")
            elif choice == '2':
                run_camphish_v2()
                input(f"\n{GREEN}Eksekusi selesai. Tekan Enter untuk kembali ke menu utama...")
            elif choice == '0':
                clear_screen()
                print(f"{CYAN}JUST HOPING TO BE HER HOPE :)")
                time.sleep(1)
                sys.exit(0) # Keluar dari program
            else:
                print(f"{RED}Pilihan tidak valid, silakan coba lagi.")
                time.sleep(2)
        
        except KeyboardInterrupt:
             clear_screen()
             print(f"\n{CYAN}Program dihentikan oleh pengguna. Sampai jumpa!")
             sys.exit(0)

# Baris ini memastikan fungsi main() hanya berjalan saat file dieksekusi sebagai skrip
if __name__ == "__main__":
    main()