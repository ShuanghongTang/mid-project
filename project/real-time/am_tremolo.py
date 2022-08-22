import tkinter as Tk
import pyaudio, wave, struct, math
import numpy as np

root = Tk.Tk()


def fun_quit():
    global CONTINUE
    CONTINUE = False
    print('Good bye')
    # root.destroy()


f1 = Tk.DoubleVar()

# Initialize Tk variables
f1.set(50)  # f1 : frequency of sinusoid (Hz)
S_freq = Tk.Scale(root, label='Frequency', variable=f1, from_=1, to=100, tickinterval=100)
S_freq.pack(side=Tk.LEFT)

B_quit = Tk.Button(root, text='Quit', command=fun_quit)
B_quit.pack(side=Tk.BOTTOM, fill=Tk.X)

WIDTH = 2           # bytes per sample
CHANNELS = 1        # mono
RATE = 8000         # frames per second
BLOCKLEN = 1024     # block length in samples
DURATION = 13      # Duration in seconds
signal_length=RATE*DURATION

K = int( DURATION * RATE / BLOCKLEN )   # Number of blocks

print('Block length: %d' % BLOCKLEN)
print('Number of blocks to read: %d' % K)
print('Duration of block in milliseconds: %.1f' % (1000.0 * BLOCKLEN/RATE))

# Open the audio stream
# Initialize the output block
output_block = BLOCKLEN * [0]

p = pyaudio.PyAudio()
PA_FORMAT = p.get_format_from_width(WIDTH)
stream = p.open(
    format = PA_FORMAT,
    channels = CHANNELS,
    rate = RATE,
    input = True,
    output = True)

file_name = 'output.wav'  # Name of output wavefile
wf = wave.open(file_name, 'w')  # wf : wave file
wf.setnchannels(1)  # one channel (mono)
wf.setsampwidth(2)  # two bytes per sample (16 bits per sample)
wf.setframerate(RATE)  # samples per second

MAXVALUE = 2**15-1  # Maximum allowed output signal value (because WIDTH = 2)
alpha = 0.5
BLOCKLEN = 64

CONTINUE = True
while CONTINUE:
    for i in range(0, int(signal_length/BLOCKLEN)):
        root.update()
        # Convert binary data to number
        input_bytes = stream.read(BLOCKLEN, exception_on_overflow=False)
        input_tuple = struct.unpack('h'*BLOCKLEN, input_bytes)  # One-element tuple
        input_value = input_tuple  # Number

        # Set input to difference equation
        x0 = input_value

        # Difference equation
        output_block = [int((1+alpha*math.sin(2*math.pi*i*f1.get()/RATE))*n) for n in input_tuple]

        y0_out = np.clip(output_block, -MAXVALUE, MAXVALUE)
        output_string = struct.pack('h'*BLOCKLEN, *y0_out)  # 'h' for 16 bits
        stream.write(output_string)
        wf.writeframes(output_string)
        if not CONTINUE:
            break

stream.stop_stream()
stream.close()
p.terminate()

print('* Finished')
