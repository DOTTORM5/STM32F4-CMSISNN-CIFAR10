from sqlite3 import Time
import cv2
import serial as ser

"""
0 - Airplane
1 - Automobile
2 - Bird
3 - Cat
4 - Deer
5 - Dog
6 - Frog
7 - Horse
8 - Ship
9 - Truck
"""

def read_and_resize_image(path, x,y):
    img = cv2.imread(path)
    res = cv2.resize(img, dsize=(x, y), interpolation=cv2.INTER_CUBIC)
    return res

def show_image(path):
    img = read_and_resize_image(path,100,100)
    cv2.imshow("image",img)
    print("Press (0) to close\n")
    cv2.waitKey(0)
    cv2.destroyAllWindows()

def compute(device, path, verbose):

    classes = ["Airplane", "Automobile", "Bird", "Cat", "Deer", "Dog", "Frog", "Horse", "Ship", "Truck"]
    
    if verbose == True:
        print("Image to be processed: "+path)
        print("Device to communicate with: "+device)

    
    if verbose == True:
        print("Reading and resizing the image...")

    #Preprocessing per adattare il formato dell'immagine con quella definita dall'MCU
    img = read_and_resize_image(path,32,32) #MCU vuole l'immagine 32x32
    img_raw = [in3 for in1 in img for in2 in in1 for in3 in in2] #L'immagine da passare deve essere in un formato grezzo: [r1 g1 b1 r2 g2 b2 ... ... ... rn gn bn ]
    img_raw = b"".join([int(i).to_bytes(1, 'little') for i in img_raw])

    if verbose == True:
        print("Sending the image...")
    
    #Invio dell'immagine tramite seriale
    stm = ser.Serial(device, 115200, timeout=None)
    stm.write(img_raw)

    if verbose == True:
        print("Image sent!")
        print("Waiting the process and receiving the results...")
    
    classification = stm.read(size=10)
    
    if verbose == True:
        print("Results received!")

    #Elaborazione dei risultati in base alle classi a disposizione
    #Ad ogni classe è associato un numero maggiore di 0.
    #Più alto è il numero, più l'MCU è sicuro nell'associare l'immagine ricevuta alla classe
    classification = {classes[i]: classification[i] for i in range(len(classes))}
    
    return classification

