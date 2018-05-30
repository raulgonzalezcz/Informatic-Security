from collections import deque
import random

keyVector = []
def encryptVigenere(plaintext, key):
    vigenereBytes = []
    key_length = len(key)
    key_as_int = key
    plaintext_int = plaintext
    conta = 0
    for i in range(len(plaintext_int)):
        if(plaintext_int[i] == 32):
            #Blank space detected, we only add it to the cipher text
            #print(plaintext_int[i])
            vigenereBytes.append(32)
            conta -= 1
        else:
            value = (plaintext_int[i] + key_as_int[(i + conta) % key_length]) % 256
            vigenereBytes.append(value - keyVector[0])
    return vigenereBytes



def decryptVigenere(vigenereBytes, key):
    result = []
    key_length = len(key)
    key_as_int = key
    ciphertext_int = vigenereBytes
    conta = 0
    for i in range(len(ciphertext_int)):
        if(ciphertext_int[i] == 32):
            #Blank space detected, we only add it to the cipher text
            #print(plaintext_int[i])
            result.append(32)
            conta -= 1
        else:
            value = (ciphertext_int[i] - key_as_int[(i + conta) % key_length]) % 256
            result.append(value + keyVector[0])
    return result

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
    plaintext = 'ABCD'
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

    #Step1. Perform RC4
    Crc4Vector = []
    Crc4Text = ""
    p = 0
    for c in plaintext:
        xor = (ord(c) ^ keyVectorRc4[p])
        Crc4Vector.append(xor)
        Crc4Text += ("%02X" % xor) #Cipher text of rc4 in Hexadecimal
        p = p + 1

    print("Encrypted text with RC4: " + Crc4Text)
    print("Length of Crc4:")
    print(len(Crc4Vector))

    #Get Vigenere Ciphertext
    Cvrc4 = ""
    #Choose J for c1 and c2
    j = random.randint(0,(len(Crc4Vector)))
    print("Selected J: ")
    print(j)

    #vigenere encryption of c1, c2
    c1 = encryptVigenere(Crc4Vector[0:j], keyVectorRc4[0:j])
    c2 = encryptVigenere(Crc4Vector[j:len(Crc4Vector)], keyVectorRc4[j:len(Crc4Vector)])
    print("C1 generated: ")
    print(c1)
    print("C2 generated: ")
    print(c2)

    #generate CVigenere
    c =[]
    for element in c1:
        c.append(element)
    for element in c2:
        c.append(element)

    #From ASCII code to letters
    for i in c:
        Cvrc4 += chr(i)
    Cvrc4 += str(j)
    print("The CVigenere ciphertext is : " + Cvrc4)
    print("=======================================")
    print("Decrypting ciphertext...")
    DC1 = decryptVigenere(c1, keyVectorRc4[0:j])
    DC2 = decryptVigenere(c2, keyVectorRc4[j:len(Crc4Vector)-1])
    Crc4Mix = []
    print("Decrypted DC1: ")
    print(DC1)
    print("Decrypted DC2: ")
    print(DC2)
    #Generate Crc4
    for element in DC1:
        Crc4Mix.append(element)
    for element in DC2:
        Crc4Mix.append(element)
    #Get the decrypted message
    decryptedText = ""
    keystream = RC4(keyVector)
    for c in Crc4Mix:
        xor = ( c ^ keystream.next())
        decryptedText += ("%02X" % xor) #decipher text of rc4
    #Show decrypted message
    #print("Decrypted text: " + decryptedText.decode("hex"))


    decryptedText = ""
    keystream = RC4(keyVector)
    for c in Crc4Text.decode("hex"):
        xor = (ord(c) ^ keystream.next())
        decryptedText += ("%02X" % xor) #decipher text of rc4

    #Decrypt
    print("Decrypted text: " + decryptedText.decode("hex"))
