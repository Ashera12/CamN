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
    print(f"{CYAN}[1]{WHITE} CamPhish V1")
    print(f"{CYAN}[2]{WHITE} CamPhish V2")
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

def main():
    run_tts("Welcome to the program!", rate=0)
    run_tts("My name is SomniumN1, I am a programmer", rate=1)
    time.sleep(1.5)  # Pastikan TTS selesai sebelum melanjutkan

    while True:
        show_menu()
        try:
            choice = input(f"{YELLOW}Pilih opsi: {RESET}")
            if choice == '1':
                run_camphish("CamPhish", "camphish.sh")
                input(f"\n{GREEN}Selesai. Tekan Enter untuk kembali ke menu.")
            elif choice == '2':
                run_camphish("HACK-CAMERA", "hack_camera.sh")
                input(f"\n{GREEN}Selesai. Tekan Enter untuk kembali ke menu.")
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
