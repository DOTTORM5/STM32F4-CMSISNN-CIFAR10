CMSIS NN Lib example arm_nnexample_cifar10 for
  Cortex-M4 and Cortex-M7.

1. Generare l'eseguibile per il microcontrollore e caricarlo
	$ make 
	# make flash

2. Eseguire il programma python per interagire con MCU
	$ cd script
	$ python cifar10.py -h
	$ pyhton cifar10.py -d /dev/ttyACM0 -i frog1.jpg
	(attendere i risultati)

Dipendenze python: pyserial opencv-python
