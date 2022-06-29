
from getopt import getopt
from stm32_cifar10 import *
import getopt
import sys

def print_help():
    print("Usage: cifar10.py [-i xxxxx.jpg] {-a xx/../yy/ww.jpg} {-d /dev/ttyXX} {-v} {-h}\n")
    print("Available options:")

    print("-d or --device        : Insert the serial port" )
    print("-i or --image         : Insert the name of an image in '../images' path" )
    print("-a or --absolute-path : Insert the absolute path of an image" )
    print("-v or --verbose       : Execute the program in verbose mode" )
    print("-h or --help " )

    print("You have to enter an image path through '-i' or '-a'")

if __name__ == "__main__":

    
    device = "/dev/ttyACM0"
    base_img_path = "../images/"
    path_img = base_img_path+"truck1.jpg"


    verbose = False
    mandatory = [False] #Lista di check per parametri obbigatori

    args = sys.argv[1:]
    try:
        opts,args = getopt.getopt(args, "d:i:vha:", ["device=", "image=", "absolute-path","verbose", "help"])
    except getopt.GetoptError:
        print("Bad usage!")
        print_help()
        sys.exit(1)
 
    
    for opt,value in opts:
        if opt in ("-i", "--image"):
            path_img = base_img_path+value
            mandatory[0] = True
        elif opt in ("-a", "--absolute-path"):
            path_img = value
            mandatory[0] = True
        elif opt in ("-d", "--device"):
            device = value; 
        elif opt in ("-v", "--verbose"):
            verbose = True
        elif opt in ("-h", "--help"):
            print_help()
            sys.exit(2)
        
    if False in mandatory:
        print("Mandatory arguments are missing!")
        print_help()
        sys.exit(3)


    res = compute(device, path_img, verbose)
    print(res)
    show_image(path_img)
    
