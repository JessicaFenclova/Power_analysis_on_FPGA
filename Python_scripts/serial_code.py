import serial
from serial import Serial

def pick_command():
    cmd=input("Pick a command: \n 1: Set LSB in LFSR \n 2: Set MSB in LFSR \n 3: Set number of S-box \n 4: Start measurement \n")
    cmd=int(cmd)
    print(cmd)
    if(cmd==4):
        print("No parameter required.")
        param=0


    else:
        param=input("Enter the parameter 5 bits corresponding to the command in binary form: \t ")
        param=int(param,2)

    print(param)



    #param=input("Enter the parameter 5 bits corresponding to the command in binary form: \t ")
    #param=int(param,2)
     # if cmd 1 or 2 then param is the seed of the lfsr, if cmd 3 the param is the number of s-box


    if cmd==1:
        byte1=int('00000000',2)
    elif cmd==2:
        byte1=int('00000001',2)
    elif cmd==3:
        byte1=int('00000010',2)
    elif cmd==4:
        byte1=int('00000011',2)

    print(bin(byte1))
    #print(bin(param<< 3))
    byte2=(param<< 3)
    print(bin(byte2))
    #byte2= int('11110000', 2)
    #print(bin(byte1 | byte2))
    byte_aes=(byte1 | byte2)
    print(bin(byte_aes))
    #byte=
    return byte_aes

#def send_cmd_param(byte_send):
    #print(byte_send)
    #byte=cmd
    #ser.write(byte_send)

    #ser.readall()
#functions for serial communication and for setting the cmd and param and sending it to the FPGA
def eval_result(xor_data):
    if(xor_data==0):
        print("Result data correct")
    else:
        print("Result data incorrect")





ser=0

def init_serial(com_port,data):
    #COMNUM=2
    global ser

    ser= serial.Serial()#com_port, 115200, 8, serial.STOPBITS_ONE
    ser.baudrate = 115200
    ser.port = com_port

    #ser.timeout = 10
    ser.open()
    # a message said that the com port was already open,
    # com ports have to be physical which is when something is actually connected to PC

    if ser.isOpen():
        print ("Open: " + ser.portstr)

    #print(trans_byte)
    ser.timeout=5
    ser.write(data)
    ser.flush()
    #sleep
    # if inwaiting >0 no data
    # delete while

    while 1:
        try:
            #time.sleep(0.01), sleep 1
            #wait=ser.port.inWaiting, if waiting=1 or 0
            #print(wait)
            rec_byte=ser.read() #readall
            print ("Received data:" + rec_byte.decode("ascii")) #hex instead of ascii, check how many
            eval_result(rec_byte)
            #break
            #raise Exception("Woah")
        except serial.SerialException:
            print ("Device has not sent data")
            ser.close()
            exit(0) # 0 ok, 1 error


        #except Exception:
            #print("Keyboard Interrupt") # ctrl+c
            #break
            #pass



    ser.close()

    if not(ser.isOpen()):
        print ("Closed")

trans_byte=pick_command()
#print(trans_byte)
init_serial('com3',trans_byte)
enter=input("Press enter if you wish to send another command")
if(enter==""):
    trans_byte=pick_command()
    #print(trans_byte)
    init_serial('com3',trans_byte)



#send_cmd_param(byte)
#ser.write(trans_byte)
