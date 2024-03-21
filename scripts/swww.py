
import os
import subprocess
import random
import time

def find_wallpapers(directory):
    wallpapers = []
    for root, _, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                wallpapers.append(os.path.join(root, file))
    return wallpapers

def setup_swww():
    subprocess.run(["swww", "init"])

def set_wallpaper(wallpaper):
    # subprocess.run(["swww", "img","-t","grow","--transition-pos","bottom-right", wallpaper])
    subprocess.run(["swww", "img","-t","simple", wallpaper])

def main():
    wallpaper_directory = "/home/caches/Pictures/Wallpapers"
    wallpapers = find_wallpapers(wallpaper_directory)
    
    if wallpapers:
        setup_swww()
        while True:
            random_wallpaper = random.choice(wallpapers)
            set_wallpaper(random_wallpaper)
            time.sleep(180)
    else:
        print("No wallpapers found in the specified directory.")

if __name__ == "__main__":
    main()

