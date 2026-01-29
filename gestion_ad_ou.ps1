### FONCTION #############################################################################

function f_choix_ou {

    Write-Host "`n*** MENU GESTION UNITES D'ORGANISATIONS :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Afficher les unites d'organisations (Avec les principales informations)
    `n2 - Creer une unite d'organisation a la racine du domaine
    `n3 - Creer une unite d'organisation dans une unite d'organisation
    `n4 - Creer plusieurs unites d'organisations a la racine du domaine (fichier csv\ad_create_ou.csv)
    `n5 - Creer plusieurs unites d'organisations dans une unite d'organisation  (fichier csv\ad_create_ou.csv)
    `n6 - Quitter `n"

    $choix = Read-Host "`n*** Que voulez-vous faire ?"

    switch ($choix) {

        "1" {
            Get-ADOrganizationalUnit -Filter * -Properties * |
                Format-Table Name, DistinguishedName, Created, LinkedGroupPolicyObjects
        }

        "2" {
            $nom_ou = Read-Host "`n*** Comment nommer l'unite d'organisation ? (ex: Utilisateurs)"
            New-ADOrganizationalUnit -Name $nom_ou
        }

        "3" {
            $nom_ou = Read-Host "`n*** Comment nommer l'unite d'organisation ? (ex: Mon_OU)"
            $chemin_ou = Read-Host "`n*** Emplacement pour l'unite d'organisation ? (ex: OU=Mon_OU_parent,OU=Mon_OU_racine,DC=DOMAINE,DC=LOCAL)"
            New-ADOrganizationalUnit -Name $nom_ou -Path $chemin_ou
        }

        "4" {
            $CSVFile = ".\csv\ad_create_ou.csv"
            $CSVData = Import-CSV -Path $CSVFile -Encoding UTF8

            foreach ($nom_ou in $CSVData) {
                New-ADOrganizationalUnit -Name $nom_ou.nomOU
            }
        }

        "5" {
            $CSVFile = ".\csv\ad_create_ou.csv"
            $CSVData = Import-CSV -Path $CSVFile -Encoding UTF8
            $chemin_ou = Read-Host "`n*** Emplacement pour les unites d'organisations ? (ex: OU=Mon_OU_parent,OU=Mon_OU_racine,DC=DOMAINE,DC=LOCAL)"

            foreach ($nom_ou in $CSVData) {
                New-ADOrganizationalUnit -Name $nom_ou.nomOU -Path $chemin_ou
            }
        }

        "6" {
            exit
        }

        default {
            Write-Warning "Erreur de choix !"
            f_choix_ou
        }
    }

    f_choix_ou
}

### PROGRAMME PRINCIPAL #################################################################


f_choix_ou