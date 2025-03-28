# ATELIER 1

Dans le fichier **roles/add_text_to_file/tasks/main.yml**, réaliser les actions suivantes :

1. En utilisant le module **command**, exécuter la commande `touch file` pour créer un fichier vide :

   *module : [https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html)*

2. En utilisant le module **lineinfile**, ajouter une ligne dans le fichier `test` créé précédemment.

   **Important** : le contenu de la ligne doit être inséré en utilisant la variable du playbook `text_to_copy`.

   *module : [https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html)*

3. Exécuter le playbook `add_line_to_file` en utilisant la commande `ansible-playbook`.






