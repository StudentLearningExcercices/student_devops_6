
#TODO : Créer le fichier file_1.txt dans le dossier ./code
# ...
resource "local_file" "first_file" {
  content = "THIS IS A TEST"
  filename = "./code/file_1.txt"
}

#TODO : Créer le fichier file_2.txt dans le répertoire ./code/directory
# ...
resource "local_file" "second_file" {
  content = "THIS IS A TEST"
  filename = "./code/directory/file_2.txt"
}