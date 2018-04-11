
def encrypt(plaintext, key):
    vigenereBytes = []
    key_length = len(key)
    plaintext = plaintext
    key_as_int = [ord(i) for i in key]
    plaintext_int = [ord(i) for i in plaintext]
    conta = 0
    for i in range(len(plaintext_int)):
        if(plaintext_int[i] == 32):
            #Blank space detected, we only add it to the cipher text
            #print(plaintext_int[i])
            vigenereBytes.append(32)
            conta -= 1
        else:
            value = (plaintext_int[i] + key_as_int[(i + conta) % key_length]) % 256
            vigenereBytes.append(value - key_as_int[0])
    return vigenereBytes


def decrypt(vigenereBytes, key):
    key_length = len(key)
    key_as_int = [ord(i) for i in key]
    ciphertext_int = vigenereBytes
    plaintext = ''
    conta = 0
    for i in range(len(ciphertext_int)):
        if(ciphertext_int[i] == 32):
            #Blank space detected, we only add it to the cipher text
            #print(plaintext_int[i])
            plaintext += chr(32)
            conta -= 1
        else:
            value = (ciphertext_int[i] - key_as_int[(i + conta) % key_length]) % 256
            plaintext += chr(value + key_as_int[0])
    return plaintext

message = "Hello World"
key = "ABCD"
print("Message: " + message)
print("Key: " + key)
encriptado = encrypt(message, key)
print("Encrypted: " + "".join(map(chr, encriptado)))
desencriptado = decrypt(encriptado, key)
print("Decrypted: "+desencriptado)