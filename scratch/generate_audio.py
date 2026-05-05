import wave
import struct
import random
import math
import os

def generate_wav(filename, duration_sec, frequency_fn):
    sample_rate = 44100
    num_samples = int(sample_rate * duration_sec)
    
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(sample_rate)
        
        for i in range(num_samples):
            value = frequency_fn(i, sample_rate)
            # Clamp and convert to 16-bit PCM
            value = max(-1.0, min(1.0, value))
            sample = int(value * 32767)
            wav_file.writeframesraw(struct.pack('<h', sample))

def white_noise_fn(i, rate):
    return random.uniform(-1.0, 1.0)

def brown_noise_generator():
    last_val = 0.0
    while True:
        # Brown noise is the integral of white noise
        # We use a leaky integrator to keep it centered
        white = random.uniform(-0.05, 0.05)
        last_val = 0.99 * last_val + white
        yield last_val

brown_gen = brown_noise_generator()
def brown_noise_fn(i, rate):
    return next(brown_gen)

def heartbeat_fn(i, rate):
    # Two pulses: lub-dub
    # 60 BPM = 1 beat per second
    t = (i % rate) / rate
    
    # Pulse 1 (Lub)
    p1 = math.exp(-100 * (t - 0.2)**2) * math.sin(2 * math.pi * 40 * t)
    # Pulse 2 (Dub)
    p2 = 0.7 * math.exp(-100 * (t - 0.4)**2) * math.sin(2 * math.pi * 35 * t)
    
    return p1 + p2

def pink_noise_generator():
    # Voss-McCartney algorithm approximation
    # Good for rain/wind sounds
    b = [0] * 16
    while True:
        r = random.uniform(-1, 1)
        i = 0
        while i < 16:
            if (random.random() > 0.5):
                b[i] = r
                break
            i += 1
        yield sum(b) / 16.0

pink_gen = pink_noise_generator()
def pink_noise_fn(i, rate):
    return next(pink_gen) * 2.0

output_dir = 'murmur/assets/audio'
os.makedirs(output_dir, exist_ok=True)

print("Generating White Noise...")
generate_wav(os.path.join(output_dir, 'white_noise.wav'), 10, white_noise_fn)
print("Generating Brown Noise...")
generate_wav(os.path.join(output_dir, 'brown_noise.wav'), 10, brown_noise_fn)
print("Generating Heartbeat...")
generate_wav(os.path.join(output_dir, 'heartbeat.wav'), 10, heartbeat_fn)
print("Generating Pink Noise (Rain/Wind)...")
generate_wav(os.path.join(output_dir, 'pink_noise.wav'), 10, pink_noise_fn)

print("Done!")
