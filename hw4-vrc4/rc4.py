from collections import deque
import random

keyVector = []

#Initial Permutation of S 
def KSA(key):
    keylength = len(key)

    S = range(256)

    j = 0
    for i in range(256):
        j = (j + S[i] + key[i % keylength]) % 256
        S[i], S[j] = S[j], S[i]  # swap

    return S

# Stream Generation 
def StreamGeneration(S):
    i = 0
    j = 0
    while True:
        i = (i + 1) % 256
        j = (j + S[i]) % 256
        S[i], S[j] = S[j], S[i]  # swap

        K = S[(S[i] + S[j]) % 256]
        yield K

#Return an a vector
def convert_key(s):
        return [ord(c) for c in s] #obtine su codigo ASCII (a = 97)

def RC4(key):
    S = KSA(key)
    return StreamGeneration(S)


if __name__ == '__main__':

    keyText = 'ABCD'
    plaintext = 'Hello world'
    print("Plaintext: " + plaintext)
    print("Key: "+keyText)

    keyVector = convert_key(keyText)
    keystream = RC4(keyVector)
    #Generate the key RC4
    keyVectorRc4 = []
    c = 0
    for i in range(256):
        keyVectorRc4.append(keystream.next())
        c += 1
    print("Key vector size: " + str(len(keyVectorRc4)))

    Crc4Vector = []
    #Ciphertext
    Crc4Text = ""
    #RC4 implementation
    p = 0
    for c in plaintext:
        xor = (ord(c) ^ keyVectorRc4[p])
        Crc4Vector.append(xor)
        Crc4Text += ("%02X" % xor) #Cipher text of rc4 in Hexadecimal
        p = p + 1

    print("Encrypted text: " + Crc4Text)
    print("Encrypted text size: " + str(len(Crc4Vector)))

    #Decrypted text
    decrypted = ""
    keystream = RC4(keyVector)
    for c in Crc4Text.decode("hex"):
        xor = (ord(c) ^ keystream.next())
        decrypted += ("%02X" % xor) #decipher text of rc4

    #Decrypt
    print("Decrypted text: " + decrypted.decode("hex"))
