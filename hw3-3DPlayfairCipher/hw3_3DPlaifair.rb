# -------------------------------------------------------------------
# Homework 3 - 3D Playfair
# 150154, 150822, 151211
# -------------------------------------------------------------------

# Alphabet
$super_arreglo = ["0","1","2","3","4","5","6","7","8","9",
	"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"!","\"","#","$","%","&","'","(",")","*","+",",","-",".","/",":",";","<","=",">","?","@","[","\\","]","^","_","|"]

# Standard matrix
floor1 = [["0","1","2","3"], ["4","5","6","7"], ["8","9","A","B"],["C","D","E","F"]]
floor2 = [["G","H","I","J"], ["K","L","M","N"], ["O","P","Q","R"],["S","T","U","V"]]
floor3 = [["W","X","Y","Z"], ["!","\"","#","$"], ["%","&","'","("],[")","*","+",","]]
floor4 = [["-",".","/",":"], [";","<","=",">"], ["?","@","[","\\"],["]","^","_","|"]]

$matriz = [] # Matrix 4x4x4 
$matriz << [] #0
$matriz << floor1 #1
$matriz << floor2 #2
$matriz << floor3 #3
$matriz << floor4 #4

$matriz_original = $matriz


# Obtaining the row
def getRow(letra)
	$matriz3d.each do |floor|
		floor.each_with_index do |arreglo, row|
			if(arreglo.include? letra)
				return row.to_s
			end
		end
	end
end

# Obtaining the column
def getColumn(letra)
	$matriz3d.each do |floor|
		floor.each do |arreglo|
			if(arreglo.include? letra)
				return arreglo.index(letra)
			end
		end
	end
end

# Obtaining the floor
def getFloor(letra)
	$matriz3d.each_with_index do |floor, indexFloor|
		floor.each do |arreglo|
			if(arreglo.include? letra)
				return indexFloor
			end
		end
	end
end

# Obtaining the letter of the new generated matrix
def getLetra(row, column, floor)
	return $matriz3d[floor][row][column]
end

# Obtaining the letter of the original matrix
def getLetraOriginal(row, column, floor)
	return $matriz_original[floor][row][column]
end

# Transfom the word adding 'x' where there is a replicated letter
def transormarPalabra(palabra)
	palabra = palabra.split(//)
	# Trigrams of the word
	trios = []
	remain = ""
	for letra in palabra do
	    if remain.length % 3 != 0 and letra == remain[remain.length-1]
	        remain << "X"
	        if remain.length % 3 == 0
	            trios << remain
	            remain = ""
	        end
	        remain << letra
	    else
	        remain << letra
	    end
	    if remain.length % 3 == 0
	        trios << remain
	        remain = ""
	    end
	end
	if remain.length % 3 != 0
	    remain << "X"
	end

	if(remain.length % 3 != 0)
	    remain << "Z"
	end

	trios << remain
	return trios
end


# ENCRYPTION ---------------------------------------------------

# Generating the matrix with the key
def matriz_codificada(key)
	$word = key
	# Converts the string into an array with unique symbols
	$word = $word.split(//).uniq 
	$indice_word = 0
	$indice_super_arreglo = 0

	$matriz.each_with_index do |floor, indexFloor|
		floor.each_with_index do |arreglo, row|
			arreglo.each_with_index do |letra, index|

				# puts letra
				# puts "cambió a:"
				if($indice_word < ($word.length))
					$matriz[indexFloor][row][index] = $word[$indice_word]
					$indice_word += 1
				else
					letra = $super_arreglo[$indice_super_arreglo]

					while($word.include? letra)
						$indice_super_arreglo += 1
						letra = $super_arreglo[$indice_super_arreglo]
					end

					$matriz[indexFloor][row][index] = $super_arreglo[$indice_super_arreglo]
					$indice_super_arreglo += 1
				end
				# puts $matriz[indexFloor][row][index]
				# puts "----"
			end
		end
	end
end

# Encrypt the word 
def codificarPalabra(palabra)
	#los divide por trios de letras (3 puntitos) y cada trio es un arreglo
	# palabra = palabra.scan(/.../) 

	# Trigrams of each word
	trios = []

	# Encrypted word
	$nueva_palabra = ""
	# Return arrays of trigrams
	palabra = transormarPalabra(palabra) 
	palabra.each do |p|
		# Each trigram into an array, each letter in one place
		trios << p.split(//) 
	end

	trios.each do |trio|
		trio.each_with_index do |letra, index|
			if(index == 0)
				row = getRow(trio[0])
				column = getColumn(trio[1])
				floor = getFloor(trio[2])

				#obtiene la nueva letra
				nueva_letra = getLetra(row.to_i, column.to_i, floor.to_i)
				$nueva_palabra = $nueva_palabra + nueva_letra
			end

			if(index == 1)
				row = getRow(trio[1])
				column = getColumn(trio[2])
				floor = getFloor(trio[0])

				nueva_letra = getLetra(row.to_i, column.to_i, floor.to_i)
				$nueva_palabra = $nueva_palabra + nueva_letra

			end

			if(index == 2)
				row = getRow(trio[2])
				column = getColumn(trio[0])
				floor = getFloor(trio[1])

				nueva_letra = getLetra(row.to_i, column.to_i, floor.to_i)
				$nueva_palabra = $nueva_palabra + nueva_letra

			end
		end
	end
	return $nueva_palabra
end

# DENCRYPTION --------------------------------------------------
def de_codificarPalabra(palabra)
	palabra = palabra.scan(/.../) # Divided by trigrams and each is an array
	# Trigrams of the word
	trios = []

	# Encrypted word
	$nueva_palabra = ""

	palabra.each do |p|
		trios << p.split(//) #mete cada trio en el arreglo
	end

	trios.each do |trio|
		trio.each_with_index do |letra, index|
			if(index == 0)
				row = getRow(trio[0])
				column = getColumn(trio[2])
				floor = getFloor(trio[1])

				nueva_letra = getLetraOriginal(row.to_i, column.to_i, floor.to_i)
				$nueva_palabra = $nueva_palabra + nueva_letra

			end

			if(index == 1)
				row = getRow(trio[1])
				column = getColumn(trio[0])
				floor = getFloor(trio[2])

				nueva_letra = getLetraOriginal(row.to_i, column.to_i, floor.to_i)
				$nueva_palabra = $nueva_palabra + nueva_letra

			end

			if(index == 2)
				row = getRow(trio[2])
				column = getColumn(trio[1])
				floor = getFloor(trio[0])

				nueva_letra = getLetraOriginal(row.to_i, column.to_i, floor.to_i)
				$nueva_palabra = $nueva_palabra + nueva_letra
			end
		end
	end

	if($nueva_palabra[-1] == "Z" or $nueva_palabra[-1] == "X")
		$nueva_palabra = $nueva_palabra.chomp($nueva_palabra[-1])
	end

	if($nueva_palabra[-1] == "Z" or $nueva_palabra[-1] == "X")
		$nueva_palabra = $nueva_palabra.chomp($nueva_palabra[-1])
	end

	return $nueva_palabra	
end


# -------------------------------------------------------------------
# MAIN PROGRAM
# -------------------------------------------------------------------
puts "ENTER THE KEY: "
llave = gets.strip

puts "GENERATED MATRIX: "
# ENCRYPTION & DECRYPTION
matriz_codificada(llave) #hace la nueva matriz con la llave que le des
$matriz3d = $matriz

# PRINTS THE GENERATED MATRIX 
$matriz3d.each_with_index do |floor, indexFloor|
	puts ""
	floor.each_with_index do |arreglo, row|
		print arreglo
		puts ""
	end
end

puts "ENTER THE MESSAGE: "
palabra = gets.strip

# ENCRYPTED WORD
palabra_codificada = codificarPalabra(palabra)
puts "ENCRYPTED WORD: " + palabra_codificada

# DECRYPTED WORD
palabra_descodificada = de_codificarPalabra(palabra_codificada)
puts "DECRYPTED WORD: " + palabra_descodificada