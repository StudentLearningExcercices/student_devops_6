
# Atelier 3 : InfraAsCode

Dans cette première partie, nous allons créer une application front avec un backend déployé sur une lambda en utilisant Ansible et Terraform.

- **Ansible** va nous permettre de packager notre code front et backend au format zip.
  - Dans une perspective de déploiement avec une CI/CD, Ansible sera utilisé pour décompresser le zip du front avant de le déployer.
- **Terraform** va nous permettre de créer l'ensemble de l'infrastructure décrite dans le schéma ci-dessous :

![porject_architecture.png](docs%2Fporject_architecture.png)

## Partie 1 : Packaging avec Ansible

1. Prenez le temps de parcourir le code front et backend situés dans le dossier **code**.

2. Créez deux playbooks Ansible permettant de créer les archives zip du front et du backend avec la bonne version et, si nécessaire, de décompresser le front.

3. Dans le fichier **create_front_and_backend_archives.yml** situé dans le dossier **infrastructure/ansible**, ajoutez une tâche pour créer un dossier **build** :

   - **Emplacement du dossier** : `../../build`

4. Dans le fichier **create_front_and_backend_archives.yml**, ajoutez une tâche pour créer l'archive du backend :

   - **dossier_source** : `../../build/backend-{{ version }}.zip`
   - **dossier_cible** : `../../code/backend`

5. Dans le fichier **create_front_and_backend_archives.yml**, ajoutez une tâche pour créer l'archive du front :

   - **dossier_source** : `../../build/front-{{ version }}.zip`
   - **dossier_cible** : `../../code/front`

6. Générez les archives backend et front avec la commande `ansible-playbook`.

7. Dans le fichier **unzip_archive**, ajoutez une tâche pour décompresser l'archive du front :

   - **dossier_source** : `./front-{{ version }}.zip`
   - **dossier_cible** : `./front_extracted`
   - **emplacement** : `../../build`

8. Vérifiez que le playbook fonctionne en utilisant la commande `ansible-playbook`.


## Partie 2 : Création de l'infrastructure avec Terraform

1. Dans le fichier **main.yaml**, modifiez la valeur `<changer-le-nom>` de la variable locale `component_name` avec une 
valeur qui vous est propre.

2. Créez un bucket S3 pour héberger le code du front :
   - **Nom du bucket** : `s3-${local.component_name}`

3. Rattachez les ressources suivantes au bucket précédemment créé :
   - `aws_s3_bucket_website_configuration`
   - `aws_s3_bucket_public_access_block`
   - `aws_s3_bucket_policy` ( ! N'oubliez pas le champ Resource dans le Statement)

4. Chargez les fichiers suivants dans le bucket :
   - **Nom du fichier** : `index.html`, **content_type** : `text/html`
   - **Nom du fichier** : `script.js`, **content_type** : `application/javascript`
   - **Nom du fichier** : `style.css`, **content_type** : `text/css`

5. Créez une fonction Lambda avec les propriétés suivantes :
   - **function_name**    : `lambda-${local.component_name}`
   - **role**             : `aws_iam_role.lambda_exec.arn`
   - **handler**          : `lambda_function.lambda_handler`
   - **runtime**          : `python3.8`
   - **filename**         : `../../build/backend-${var.version_backend}.zip`
   - **source_code_hash** : `filebase64sha256("../../build/backend-${var.version_backend}.zip")`

6. Appelez le module **apigateway**.

7. Modifiez l'output `s3_url` dans le fichier **output.tf**.

8. Créez l'infrastructure en utilisant la commande `terraform apply`.

9. En accédant à l'interface web et en appuyant sur le bouton, quel est le résultat ? Pouvez-vous l'expliquer ?

10. Modifiez la valeur du fichier `script.js` avec la bonne valeur dans le dossier **front_extracted**.

11. Relancez l'exécution avec la commande `terraform apply` et testez si tout fonctionne correctement.




# Atelier 4 : CI/CD

Dans cette seconde partie, nous allons créer un pipeline CI/CD en utilisant GitHub Actions.  
Ce pipeline nous permettra de simuler une chaîne complète d'intégration continue.

Dans le fichier **.github/workflows/workflow.yml**, nous allons créer deux jobs : **ci** et **cd**.

Le job **ci** va permettre de gérer l'intégration continue, tandis que le job **cd** assurera le déploiement continu.

---

## Partie 1 : CI

1. Installer les librairies Python nécessaires au backend et aux tests en utilisant la commande :

   ```bash
   pip install -r requirements.txt
   ```

2. Exécuter les tests unitaires avec la commande :

   ```bash
   pytest .
   ```

3. Lancer la commande `ansible-playbook` qui permet de générer les archives zip du backend et du front en utilisant la variable `VERSION`.  
   
   **NB** : Pour récupérer la valeur de la version, utilisez la syntaxe : `${{ env.VERSION }}`

4. Charger le zip du backend généré par la commande précédente dans les artifacts en utilisant l'action `actions/upload-artifact@v4`.

5. Charger le zip du front généré par la commande précédente dans les artifacts en utilisant l'action `actions/upload-artifact@v4`.

---

## Partie 2 : CD

1. Récupérer le zip du backend en utilisant l'action `actions/download-artifact@v4`.

2. Récupérer le zip du front en utilisant l'action `actions/download-artifact@v4`.

3. Exécuter la commande `ansible-playbook` qui permet de décompresser l'archive du front.

4. Exécuter la commande `plan` pour simuler la création de l'infrastructure.  
   
   Ajouter les variables d'environnement suivantes :

   - `AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}`
   - `AWS_DEFAULT_REGION: ${{ secrets.AWS_DEFAULT_REGION }}`
   - `AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}`
