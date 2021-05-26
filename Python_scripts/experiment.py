import serial
from serial import Serial
from random import randrange


############## start of defined functions ############################

def lfsr_generate(init_byte):
    init_zero=(init_byte & (~0xFE))
    #print(bin(lfsr_zero))
    init_two=(init_byte & (~0xFB))
        #print(bin(lfsr_two))
    init_three=(init_byte & (~0xF7))
    #print(bin(lfsr_three))
    init_four=(init_byte & (~0xEF))
    #print(bin(lfsr_four))
    new_byte=(init_byte<<1)
    new_byte &= 0xFE
    print(bin(new_byte))
    lfsr_xored=(init_zero ^ (init_two>>2) ^ (init_three>>3) ^ (init_four>>4))  #XOR 0 with 2 with 3 with 4
    #print(lfsr_xored)
    new_byte |= (lfsr_xored)
    print(bin(new_byte))
    # save to file
    file = open("plaintext_file.txt", "a")
    #new_lfsr_byte=new_byte.to_bytes(1,'big')
    # Write bytes to file
    file.write(str(new_byte)+"\n")
    # Close file
    file.close()


    return new_byte

#function for sending serial data
def serial_commun(com_port,cmd_data, param_data):

    byte2=(param_data<< 3)
    #print(bin(byte2))
    data=(cmd_data | byte2)
    #print(bin(data))

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

############## end of defined functions ############################


num_of_cycles=input("Enter the number of cycles of measuring that should be done: \n")

for i in range(1,int(num_of_cycles)):
    print("This is cycle number " + num_of_cycles)
    #measurement starts by setting seed in lfsr
    #cmd eiher 1-LSB or 2-MSB
    lsb_or_msb=randrange(2) #careful, it generates 0 as well
    print(lsb_or_msb)
    cmd=lsb_or_msb
    # the param is the seed for lfsr, might also be randomly generated
    param=26 #11010
    #call the function for sending serial data
    #serial_commun(com_port,cmd_data, param_data), but with ('com3', cmd, param)
    #serial_commun('com3', cmd, param)

    #lfsr process
    lfsr_byte=int('11111111',2)
    if cmd==1:
        lfsr_byte &= 0xF0
        lfsr_byte |= param

    elif cmd==2:
        lfsr_byte &= ~0xF0
        #print(bin(lfsr_byte))
        param &= 0xF
        #print(bin(param))
        lfsr_byte |= (param<<4)

    print(bin(lfsr_byte))
    #the lfsr generator, this maybe has to be called over and over with the last ouput of fce as the input to fce
    new_plaintext_input_sbox=lfsr_generate(lfsr_byte)
    print(bin(new_plaintext_input_sbox))
    #next cmd for setting how many sboxes will be used
    cmd=3
    # number of sboxes used
    param=1
    # call function for sending serial data
    #serial_commun(com_port,cmd_data, param_data), but with ('com3', cmd, param)

    #next cmd for starting measurement
    cmd=4
    # no param
    #call function for sending serial data
    #serial_commun(com_port,cmd_data, param_data), but with ('com3', cmd, param)
